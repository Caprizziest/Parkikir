from rest_framework import serializers
from App.models import User

# kayak Resources laravel

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'