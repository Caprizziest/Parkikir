from django.db import models
from django.contrib.auth.models import User


# class User(models.Model):
#     username = models.CharField(max_length=45, unique=True)
#     password = models.TextField()
#     email = models.EmailField(max_length=45, unique=True)
#     role = models.CharField(max_length=45)

#     def __str__(self):
#         return self.username

class SlotParkir(models.Model):
    slotparkirid = models.CharField(max_length=5, primary_key=True)
    status = models.CharField(max_length=45)

    def __str__(self):
        return self.slotparkirid

class Booking(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    slotparkir = models.ForeignKey(SlotParkir, on_delete=models.CASCADE)
    tanggal = models.DateField()
    status = models.CharField(max_length=45)
    totalharga = models.IntegerField()

    def __str__(self):
        return f"Booking {self.id} for {self.user.username}"


class Laporan(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    topic = models.CharField(max_length=45, default="Parkir Sembarangan")
    gambar = models.BinaryField()  # Changed BLOB to BinaryField for Django compatibility
    lokasi = models.CharField(max_length=45, null=True, blank=True)
    status = models.CharField(max_length=45)
    tanggal = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Laporan {self.id} by {self.user.username}"


class Notice(models.Model):
    noticeid = models.AutoField(primary_key=True)
    tanggal = models.CharField(max_length=45)
    event = models.CharField(max_length=45)
    judul = models.CharField(max_length=45)
    description = models.CharField(max_length=45, null=True, blank=True)

    def __str__(self):
        return f"Notice {self.noticeid} - {self.judul}"

class ParkiranTertutup(models.Model):
    slotparkir = models.ForeignKey(SlotParkir, on_delete=models.CASCADE)
    notice = models.ForeignKey(Notice, on_delete=models.CASCADE)

    def __str__(self):
        return f"ParkiranTertutup for Slot {self.slotparkir.slotparkirid} with Notice {self.notice.noticeid}"


class Payment(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    order_id = models.CharField(max_length=100, unique=True)  # e.g., BOOKING-1
    transaction_id = models.CharField(max_length=100, blank=True, null=True)
    gross_amount = models.IntegerField()
    snap_token = models.CharField(max_length=200, blank=True, null=True)
    redirect_url = models.URLField(blank=True, null=True)
    status = models.CharField(max_length=50, default='pending')  # pending, success, failed
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Payment for {self.order_id}"