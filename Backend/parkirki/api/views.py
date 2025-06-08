from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.contrib.auth.hashers import check_password
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import *
from .utils import Util
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from django.contrib.sites.shortcuts import get_current_site
from django.urls import reverse
from django.conf import settings
import jwt
import midtransclient
import time


from django.contrib.auth.models import User
import App.models as models
from App.models import Payment, Booking


# Autentikasi
@swagger_auto_schema(method='get', operation_description="Get all user")
@api_view(['GET'])
def getData(request):
    users = User.objects.all()
    serializer = UserSerializer(users, many=True)
    return Response(serializer.data)

@swagger_auto_schema(
    method='post',
    request_body=RegisterSerializer,
    operation_description="Register new user and send email verification link"
)
@api_view(['POST'])
def register(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        user_data = serializer.data
        user = User.objects.get(email=user_data['email'])
        token = RefreshToken.for_user(user).access_token

        current_site = get_current_site(request).domain
        relative_link = reverse('email-verify')
        absurl = 'http://' + current_site + relative_link + "?token=" + str(token)

        email_body = f"""
        Halo {user.username},

        Selamat datang di ParkirKi'! 🎉

        Akun kamu berhasil dibuat. Untuk mengaktifkan akun dan mulai menggunakan fitur-fitur ParkirKi', silakan verifikasi email kamu dengan mengklik tautan di bawah ini:

        {absurl}

        Jika kamu tidak merasa mendaftar di ParkirKi', abaikan email ini.

        Terima kasih telah bergabung!
        Tim ParkirKi'
        """
        data = {
            'email_body': email_body,
            'to_email': user.email,
            'email_subject': 'Verify your email'
        }

        Util.send_email(data)
        return Response(user_data, status=status.HTTP_201_CREATED)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

token_param_config = openapi.Parameter(
    'token',
    in_=openapi.IN_QUERY,
    description='JWT token untuk verifikasi email',
    type=openapi.TYPE_STRING
)

@swagger_auto_schema(method='get', manual_parameters=[token_param_config])
@api_view(['GET'])
def verify_email(request):
    token = request.GET.get('token')
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
        user = User.objects.get(id=payload['user_id'])
        if not user.is_active:
            user.is_active = True
            user.save()
        return Response({'email': 'Successfully activated'}, status=status.HTTP_200_OK)
    except jwt.ExpiredSignatureError:
        return Response({'error': 'Activation link expired'}, status=status.HTTP_400_BAD_REQUEST)
    except jwt.DecodeError:
        return Response({'error': 'Invalid token'}, status=status.HTTP_400_BAD_REQUEST)
    
@swagger_auto_schema(
    method='post',
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        properties={
            'username': openapi.Schema(type=openapi.TYPE_STRING),
            'password': openapi.Schema(type=openapi.TYPE_STRING),
        },
        required=['username', 'password']
    ),
    operation_description="Login and obtain JWT"
)
@api_view(['POST'])
def login(request):
    username = request.data.get('username')
    password = request.data.get('password')

    if not username or not password:
        return Response(
            {"detail": "Username and password are required."},
            status=status.HTTP_400_BAD_REQUEST
        )
    try:
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        return Response(
            {'detail': 'Invalid credentials'},
            status=status.HTTP_401_UNAUTHORIZED
        )
    if not check_password(password, user.password):
        return Response(
            {'detail': 'Invalid credentials'},
            status=status.HTTP_401_UNAUTHORIZED
        )
    refresh = RefreshToken.for_user(user)
    return Response({
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    })
    
@swagger_auto_schema(
    method='post',
    request_body=LogoutSerializer,
    operation_description="Logout user by blacklisting the refresh token"
)
@api_view(['POST'])
def logout(request):
    serializer = LogoutSerializer(data=request.data, context={'request': request})
    serializer.is_valid(raise_exception=True)
    serializer.save()

    return Response(status=status.HTTP_204_NO_CONTENT)

# Slot Parkir
@swagger_auto_schema(methods=['post'], request_body=SlotParkirSerializer)
@api_view(['GET', 'POST'])
def slotparkir_list_create(request):
    if request.method == 'GET':
        data = models.SlotParkir.objects.all()
        serializer = SlotParkirSerializer(data, many=True)
        return Response(serializer.data)
    elif request.method == 'POST':
        serializer = SlotParkirSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)

@swagger_auto_schema(method='put', request_body=SlotParkirSerializer)
@api_view(['GET', 'PUT', 'DELETE'])
def slotparkir_detail(request, pk):
    try:
        slot = models.SlotParkir.objects.get(pk=pk)
    except models.SlotParkir.DoesNotExist:
        return Response(status=404)

    if request.method == 'GET':
        return Response(SlotParkirSerializer(slot).data)
    elif request.method == 'PUT':
        serializer = SlotParkirSerializer(slot, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    elif request.method == 'DELETE':
        slot.delete()
        return Response(status=204)

@swagger_auto_schema(
    method='patch',
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        properties={
            'status': openapi.Schema(type=openapi.TYPE_STRING, enum=['AVAILABLE', 'UNAVAILABLE']),
        },
        required=['status']
    ),
    operation_description="Parking Slot status update"
)
@api_view(['PATCH'])
def update_slot_status(request, pk):
    try:
        slot = models.SlotParkir.objects.get(pk=pk)
    except models.SlotParkir.DoesNotExist:
        return Response(status=404)

    status_value = request.data.get('status')
    if status_value not in ['AVAILABLE', 'UNAVAILABLE']:
        return Response({"error": "Status must be AVAILABLE or UNAVAILABLE"}, status=400)

    slot.status = status_value
    slot.save()

    # Push update ke WebSocket group
    channel_layer = get_channel_layer()
    all_slots = list(models.SlotParkir.objects.values())

    async_to_sync(channel_layer.group_send)(
        "slotparkir_group",
        {
            "type": "slotparkir_update",
            "data": all_slots
        }
    )

    return Response({"status": slot.status})

# Booking
@swagger_auto_schema(methods=['post'], request_body=BookingSerializer)
@api_view(['GET', 'POST'])
def booking_list_create(request):
    if request.method == 'GET':
        data = models.Booking.objects.all()
        return Response(BookingSerializer(data, many=True).data)
    elif request.method == 'POST':
        serializer = BookingSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)

@swagger_auto_schema(method='put', request_body=BookingSerializer)
@api_view(['GET', 'PUT', 'DELETE'])
def booking_detail(request, pk):
    try:
        obj = models.Booking.objects.get(pk=pk)
    except models.Booking.DoesNotExist:
        return Response(status=404)
    if request.method == 'GET':
        return Response(BookingSerializer(obj).data)
    elif request.method == 'PUT':
        serializer = BookingSerializer(obj, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    elif request.method == 'DELETE':
        obj.delete()
        return Response(status=204)

# Laporan
@swagger_auto_schema(methods=['post'], request_body=LaporanSerializer)
@api_view(['GET', 'POST'])
def laporan_list_create(request):
    if request.method == 'GET':
        return Response(LaporanSerializer(models.Laporan.objects.all(), many=True).data)
    elif request.method == 'POST':
        serializer = LaporanSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)

@swagger_auto_schema(
    method='patch',
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        properties={
            'status': openapi.Schema(type=openapi.TYPE_STRING, enum=['DONE', 'UNDONE']),
        },
        required=['status']
    ),
    operation_description="Change report status"
)
@api_view(['PATCH'])
def update_laporan_status(request, pk):
    try:
        laporan = models.Laporan.objects.get(pk=pk)
    except models.Laporan.DoesNotExist:
        return Response(status=404)
    status_value = request.data.get('status')
    if status_value not in ['DONE', 'NOTDONE']:
        return Response({"error": "Status must be DONE or NOTDONE"}, status=400)
    laporan.status = status_value
    laporan.save()
    return Response({"status": laporan.status})

# Notice
@swagger_auto_schema(methods=['post'], request_body=NoticeSerializer)
@api_view(['GET', 'POST'])
def notice_list_create(request):
    if request.method == 'GET':
        return Response(NoticeSerializer(models.Notice.objects.all(), many=True).data)
    elif request.method == 'POST':
        serializer = NoticeSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)

@swagger_auto_schema(methods=['post'], request_body=ParkiranTertutupSerializer)
@api_view(['GET', 'POST'])
def tertutup_list_create(request):
    if request.method == 'GET':
        return Response(ParkiranTertutupSerializer(models.ParkiranTertutup.objects.all(), many=True).data)
    elif request.method == 'POST':
        serializer = ParkiranTertutupSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)

# Midtrans - Pembayaran
@swagger_auto_schema(
    method='post',
    request_body=PaymentSerializer,
    operation_description="Generate Midtrans snap token for a booking"
)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_payment(request):
    serializer = PaymentSerializer(data=request.data)
    if not serializer.is_valid():
        return Response(serializer.errors, status=400)

    booking = serializer.validated_data['booking']

    # Init Snap client class
    snap = midtransclient.Snap(
        is_production=False,  # Change to True when in production
        server_key='SB-Mid-server-mnT8ku5J6oJftbGOe1fadh4f'
    )

    # Build parameter dict
    param = {
        "transaction_details": {
            "order_id": f"BOOKING-{booking.id}",
            "gross_amount": booking.totalharga
        },
        "customer_details": {
            "first_name": booking.user.first_name,
            "last_name": booking.user.last_name,
            "email": booking.user.email,
        }
    }

    # Get Snap payment page url
    transaction = snap.create_transaction(param)
    transaction_token = transaction['token']

    # Save payment to database
    payment = Payment.objects.create(
    booking=booking,
    user=booking.user,
    order_id=f"BOOKING-{booking.id}",
    snap_token=transaction_token,
    redirect_url=transaction['redirect_url'],
    gross_amount=booking.totalharga
)

    return Response({
        'token': transaction_token,
        'redirect_url': transaction['redirect_url'],
        'order_id': booking.id,
        'totalharga': booking.totalharga
    })

# SB-Mid-server-mnT8ku5J6oJftbGOe1fadh4f