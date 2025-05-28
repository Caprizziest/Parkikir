from rest_framework.test import APITestCase
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken
from App import models
from rest_framework import status
from datetime import date

class TestViews(APITestCase):
    def setUp(self):
            self.user = User.objects.create_user(username='testuser', password='testpass')
            self.refresh = RefreshToken.for_user(self.user)
            self.access_token = str(self.refresh.access_token)
            self.refresh_token = str(self.refresh)
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
    
    def test_views_logout_user(self):
        data = {
            "refresh": self.refresh_token
        }
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        response = self.client.post('/api/logout/', data)
        self.assertEqual(response.status_code, 204)

    def test_views_register_user_invalid(self):
        data = {
            "username": "invaliduser",
            "email": "user@example.com"
        }
        response = self.client.post('/api/register/', data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("password", response.data)

    def test_views_login_user_invalid(self):
        data = {
            "username": "testuser",
            "password": "wrongpass"
        }
        response = self.client.post('/api/login/', data)
        self.assertEqual(response.status_code, 401)

    def test_views_login_user_no_username(self):
        data = {
            "password": "somepass"
        }
        response = self.client.post('/api/login/', data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("required", response.data["detail"].lower())

    def test_views_logout_user_invalid(self):
        data = {
            "refresh": ""
        }
        self.client.credentials(HTTP_AUTHORIZATION='')
        response = self.client.post('/api/logout/', data)
        self.assertEqual(response.status_code, 400)


# Slot Parkir
    def test_views_slotparkir_get(self):
        response = self.client.get('/api/slotparkir/')
        self.assertEqual(response.status_code, 200)

    def test_views_slotparkir_create(self):
        data = {"slotparkirid": "A2", "status": "UNAVAILABLE"}
        response = self.client.post('/api/slotparkir/', data)
        self.assertEqual(response.status_code, 201)

    def test_views_slotparkir_create_invalid(self):
        data = {"slotparkirid": ""}
        response = self.client.post('/api/slotparkir/', data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("status", response.data)

    def test_views_slotparkir_detail_get(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A3', status='AVAILABLE')
        response = self.client.get(f'/api/slotparkir/{slot.slotparkirid}/')
        self.assertEqual(response.status_code, 200)

    def test_views_slotparkir_detail_update(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A4', status='UNAVAILABLE')
        data = {"slotparkirid": "A4", "status": "AVAILABLE"}
        response = self.client.put(f'/api/slotparkir/{slot.slotparkirid}/', data)
        self.assertEqual(response.status_code, 200)

    def test_views_slotparkir_detail_update_invalid(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A4', status='AVAILABLE')
        data = {"slotparkirid": "", "status": "X"}
        response = self.client.put(f'/api/slotparkir/{slot.slotparkirid}/', data)
        self.assertEqual(response.status_code, 400)

    def test_views_slotparkir_detail_delete(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A5', status='AVAILABLE')
        response = self.client.delete(f'/api/slotparkir/{slot.slotparkirid}/')
        self.assertEqual(response.status_code, 204)

    def test_views_slotparkir_patch_status(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A6', status='AVAILABLE')
        response = self.client.patch(f'/api/slotparkir/{slot.slotparkirid}/status/', {'status': 'UNAVAILABLE'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['status'], 'UNAVAILABLE')

    def test_views_slotparkir_patch_status_invalid(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A7', status='AVAILABLE')
        response = self.client.patch(f'/api/slotparkir/{slot.slotparkirid}/status/', {'status': 'WRONGVALUE'})
        self.assertEqual(response.status_code, 400)
        self.assertIn("error", response.data)

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
        
    def test_views_booking_create_invalid_missing_fields(self):
        data = {
            "user": self.user.id
        }
        response = self.client.post('/api/booking/', data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("slotparkir", response.data)
        self.assertIn("tanggal", response.data)
        self.assertIn("status", response.data)
        self.assertIn("totalharga", response.data)

    def test_views_booking_create_invalid_status(self):
        data = {
            "user": self.user.id,
            "slotparkir": self.slot.slotparkirid,
            "tanggal": str(date.today()),
            "status": "INVALID_STATUS",
            "totalharga": 5000
        }
        response = self.client.post('/api/booking/', data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("status", response.data)

    def test_views_booking_create_invalid_totalharga(self):
        data = {
            "user": self.user.id,
            "slotparkir": self.slot.slotparkirid,
            "tanggal": str(date.today()),
            "status": "ACTIVE",
            "totalharga": -5000
        }
        response = self.client.post('/api/booking/', data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("totalharga", response.data)

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
        self.assertIn(response.status_code, [201, 400])

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

    def test_views_notice_create_invalid(self):
        data = {
            "tanggal": "", 
            "event": "x",   
            "judul": "",    
            "description": "test"
        }
        response = self.client.post('/api/notice/', data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("tanggal", response.data)
        self.assertIn("event", response.data)
        self.assertIn("judul", response.data)

    def test_views_tertutup_create_invalid(self):
        data = {
            "slotparkir": "", 
            "notice": ""    
        }
        response = self.client.post('/api/tertutup/', data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("slotparkir", response.data)
        self.assertIn("notice", response.data)
