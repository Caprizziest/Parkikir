from django.db import models

class User(models.Model):
    username = models.CharField(max_length=45, unique=True)
    password = models.CharField(max_length=45)
    email = models.EmailField(max_length=45, unique=True)
    role = models.CharField(max_length=45)

    def __str__(self):
        return self.username

class SlotParkir(models.Model):
    slotparkirid = models.CharField(max_length=5, primary_key=True)
    status = models.CharField(max_length=45)

    def __str__(self):
        return self.slotparkirid

class Booking(models.Model):
    userid = models.ForeignKey(User, on_delete=models.CASCADE)
    slotparkir = models.ForeignKey(SlotParkir, on_delete=models.CASCADE)
    tanggal = models.DateField()
    status = models.CharField(max_length=45)
    totalharga = models.IntegerField()

    def __str__(self):
        return f"Booking {self.id} for {self.userid.username}"

class Laporan(models.Model):
    userid = models.ForeignKey(User, on_delete=models.CASCADE)
    gambar = models.BinaryField()  # Changed BLOB to BinaryField for Django compatibility
    lokasi = models.CharField(max_length=45, null=True, blank=True)
    status = models.CharField(max_length=45)

    def __str__(self):
        return f"Laporan {self.id} by {self.userid.username}"

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
