from rest_framework import serializers
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken, TokenError
import App.models as models

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email']


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password']

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
        )
        return user

class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField()

    default_error_message = {
        'bad_token': ('Token is expired or invalid')
    }

    def validate(self, attrs):
        self.token = attrs['refresh']
        return attrs

    def save(self, **kwargs):

        try:
            RefreshToken(self.token).blacklist()

        except TokenError:
            self.fail('bad_token')

class SlotParkirSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.SlotParkir
        fields = '__all__'

class BookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Booking
        fields = '__all__'

class LaporanSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Laporan
        fields = '__all__'

class NoticeSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Notice
        fields = '__all__'

class ParkiranTertutupSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.ParkiranTertutup
        fields = '__all__'
