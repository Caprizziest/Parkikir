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
    
    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("A user with that email already exists.")
        return value

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
        )
        user.is_active = False
        user.save()
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
    STATUS_CHOICES = (
        ('ACTIVE', 'ACTIVE'),
        ('INACTIVE', 'INACTIVE'),
    )
    
    status = serializers.ChoiceField(choices=STATUS_CHOICES)

    class Meta:
        model = models.Booking
        fields = '__all__'   
    
    def validate_totalharga(self, value):
        if value < 0:
            raise serializers.ValidationError("Total harga tidak boleh negatif.")
        return value

         
class LaporanSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Laporan
        fields = '__all__'

    def validate_status(self, value):
        if value not in ['DONE', 'UNDONE']:
            raise serializers.ValidationError("Status must be DONE or UNDONE")
        return value

    def validate_lokasi(self, value):
        if not value:
            raise serializers.ValidationError("Lokasi tidak boleh kosong")
        return value

class NoticeSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Notice
        fields = '__all__'

    def validate_tanggal(self, value):
        if not value:
            raise serializers.ValidationError("Tanggal wajib diisi.")
        return value

    def validate_event(self, value):
        if not value or len(value.strip()) < 3:
            raise serializers.ValidationError("Event terlalu pendek atau kosong.")
        return value

    def validate_judul(self, value):
        if not value or len(value.strip()) < 3:
            raise serializers.ValidationError("Judul terlalu pendek atau kosong.")
        return value

class ParkiranTertutupSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.ParkiranTertutup
        fields = '__all__'

    def validate_slotparkir(self, value):
        if not value:
            raise serializers.ValidationError("Slot parkir wajib diisi.")
        if not models.SlotParkir.objects.filter(pk=value.pk).exists():
            raise serializers.ValidationError("Slot parkir tidak ditemukan di database.")
        return value

    def validate_notice(self, value):
        if not value:
            raise serializers.ValidationError("Notice wajib diisi.")
        if not models.Notice.objects.filter(pk=value.pk).exists():
            raise serializers.ValidationError("Notice tidak ditemukan di database.")
        return value