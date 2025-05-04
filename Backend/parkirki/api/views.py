from rest_framework.response import Response
from rest_framework.decorators import api_view
from App.models import User
from .serializers import UserSerializer

@api_view(['GET'])
def getData(request):
    users = User.objects.all()
    serializer = UserSerializer(users, many=True)
    return Response(serializer.data)