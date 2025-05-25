from rest_framework.test import APITestCase
from django.contrib.auth.models import User
from App import models
from rest_framework import status
from datetime import date

class TestViews(APITestCase):
    def setUp(self):
            self.user = User.objects.create_user(username='testuser', password='testpass')
            self.slot = models.SlotParkir.objects.create(slotparkirid='A1', status='AVAILABLE')

# Autentikasi
    def test_views_get_users(self):
        response = self.client.get('/api/users/')
        self.assertEqual(response.status_code, 200)

    def test_views_register_user(self):
        data = {
            "username": "newuser",
            "password": "newpassword123",
            "email": "newuser@example.com"
        }
        response = self.client.post('/api/register/', data)
        self.assertEqual(response.status_code, 201)

    def test_views_login_user(self):
        data = {
            "username": "testuser",
            "password": "testpass"
        }
        response = self.client.post('/api/login/', data)
        self.assertEqual(response.status_code, 200)
        self.assertIn('access', response.data)

# Slot Parkir
    def test_views_slotparkir_get(self):
        response = self.client.get('/api/slotparkir/')
        self.assertEqual(response.status_code, 200)

    def test_views_slotparkir_create(self):
        data = {
            "slotparkirid": "A2",
            "status": "UNAVAILABLE"
        }
        response = self.client.post('/api/slotparkir/', data)
        self.assertEqual(response.status_code, 201)

    def test_views_slotparkir_detail_get(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A3', status='AVAILABLE')
        response = self.client.get(f'/api/slotparkir/{slot.slotparkirid}/')
        self.assertEqual(response.status_code, 200)

    def test_views_slotparkir_detail_update(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A4', status='UNAVAILABLE')
        data = {"slotparkirid": "A4", "status": "AVAILABLE"}
        response = self.client.put(f'/api/slotparkir/{slot.slotparkirid}/', data)
        self.assertEqual(response.status_code, 200)

    def test_views_slotparkir_detail_delete(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A5', status='AVAILABLE')
        response = self.client.delete(f'/api/slotparkir/{slot.slotparkirid}/')
        self.assertEqual(response.status_code, 204)

    def test_views_slotparkir_patch_status(self):
        response = self.client.patch(f'/api/slotparkir/{self.slot.slotparkirid}/status/', {'status': 'UNAVAILABLE'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['status'], 'UNAVAILABLE')

# Booking
    def test_views_booking_get(self):
        response = self.client.get('/api/booking/')
        self.assertEqual(response.status_code, 200)

    def test_views_booking_create(self):
        data = {
            "user": self.user.id,
            "slotparkir": self.slot.slotparkirid,
            "tanggal": str(date.today()),
            "status": "ACTIVE",
            "totalharga": 5000
        }
        response = self.client.post('/api/booking/', data)
        self.assertEqual(response.status_code, 201)

    def test_views_booking_detail_get(self):
        booking = models.Booking.objects.create(
            user=self.user,
            slotparkir=self.slot,
            tanggal=date.today(),
            status='ACTIVE',
            totalharga=10000
        )
        response = self.client.get(f'/api/booking/{booking.id}/')
        self.assertEqual(response.status_code, 200)

    def test_views_booking_detail_update(self):
        booking = models.Booking.objects.create(
            user=self.user,
            slotparkir=self.slot,
            tanggal=date.today(),
            status='ACTIVE',
            totalharga=10000
        )
        update = {
            "user": self.user.id,
            "slotparkir": self.slot.slotparkirid,
            "tanggal": str(date.today()),
            "status": "INACTIVE",
            "totalharga": 12000
        }
        response = self.client.put(f'/api/booking/{booking.id}/', update)
        self.assertEqual(response.status_code, 200)

    def test_views_booking_detail_delete(self):
        booking = models.Booking.objects.create(
            user=self.user,
            slotparkir=self.slot,
            tanggal=date.today(),
            status='ACTIVE',
            totalharga=10000
        )
        response = self.client.delete(f'/api/booking/{booking.id}/')
        self.assertEqual(response.status_code, 204)

# Laporan
    def test_views_laporan_get(self):
        response = self.client.get('/api/laporan/')
        self.assertEqual(response.status_code, 200)

    def test_views_laporan_create(self):
        data = {
            "user": self.user.id,
            "gambar": b"binarydata",
            "lokasi": "Dekat B2",
            "status": "UNDONE"
        }
        response = self.client.post('/api/laporan/', data)
        self.assertIn(response.status_code, [201, 400])  # tergantung validasi gambar

    def test_views_laporan_patch_status(self):
        laporan = models.Laporan.objects.create(user=self.user, gambar=b"abc", status="UNDONE")
        response = self.client.patch(f'/api/laporan/{laporan.id}/status/', {'status': 'DONE'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['status'], 'DONE')

# Notice
    def test_views_notice_get(self):
        response = self.client.get('/api/notice/')
        self.assertEqual(response.status_code, 200)

    def test_views_notice_create(self):
        data = {
            "tanggal": "2025-05-24",
            "event": "Penutupan",
            "judul": "Parkiran Ditutup",
            "description": "Event Rekfest"
        }
        response = self.client.post('/api/notice/', data)
        self.assertEqual(response.status_code, 201)

    def test_views_tertutup_get(self):
        models.Notice.objects.create(tanggal="2025-05-22", event="Penutupan", judul="Parkiran Ditutup")
        response = self.client.get('/api/tertutup/')
        self.assertEqual(response.status_code, 200)

    def test_views_tertutup_create(self):
        notice = models.Notice.objects.create(tanggal="2025-05-22", event="Penutupan", judul="Parkiran Ditutup")
        data = {
            "slotparkir": self.slot.slotparkirid,
            "notice": notice.noticeid
        }
        response = self.client.post('/api/tertutup/', data)
        self.assertEqual(response.status_code, 201)
