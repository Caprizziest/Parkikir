from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from django.contrib.auth.hashers import check_password
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import *
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from django.contrib.auth.models import User
import App.models as models

# Autentikasi
@swagger_auto_schema(method='get', operation_description="Get all user")
@api_view(['GET'])
def getData(request):
    users = User.objects.all()
    serializer = UserSerializer(users, many=True)
    return Response(serializer.data)

@swagger_auto_schema(method='post', request_body=RegisterSerializer, operation_description="Register new user")
@api_view(['POST'])
def register(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({'message': 'User registered successfully'}, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@swagger_auto_schema(method='post', request_body=openapi.Schema(
    type=openapi.TYPE_OBJECT,
    properties={
        'username': openapi.Schema(type=openapi.TYPE_STRING),
        'password': openapi.Schema(type=openapi.TYPE_STRING),
    },
    required=['username', 'password']
), operation_description="Login and obtain JWT")
@api_view(['POST'])
def login(request):
    username = request.data.get('username')
    password = request.data.get('password')

    try:
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        return Response({'detail': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

    if not check_password(password, user.password):
        return Response({'detail': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

    refresh = RefreshToken.for_user(user)
    return Response({
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    })

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

    # 🔄 Push update ke WebSocket group
    channel_layer = get_channel_layer()
    all_slots = list(models.SlotParkir.objects.values())  # atau pakai serializer jika perlu

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
