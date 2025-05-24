from rest_framework.test import APITestCase
from django.contrib.auth.models import User
from App import models
from rest_framework import status
from datetime import date

class TestViews(APITestCase):

    def setUp(self):
        self.user = User.objects.create_user(username='testuser', password='testpass')
        self.slot = models.SlotParkir.objects.create(slotparkirid='A1', status='AVAILABLE')

    def test_get_users(self):
        response = self.client.get('/api/users/')
        self.assertEqual(response.status_code, 200)

    def test_register(self):
        data = {
            "username": "newuser",
            "password": "newpassword123",
            "email": "newuser@example.com"
        }
        response = self.client.post('/api/register/', data)
        self.assertEqual(response.status_code, 201)

    def test_login(self):
        data = {
            "username": "testuser",
            "password": "testpass"
        }
        response = self.client.post('/api/login/', data)
        self.assertIn('access', response.data)
        self.assertEqual(response.status_code, 200)

    def test_slotparkir_list_create(self):
        response = self.client.get('/api/slotparkir/')
        self.assertEqual(response.status_code, 200)

        data = {
            "slotparkirid": "A2",
            "status": "UNAVAILABLE"
        }
        response = self.client.post('/api/slotparkir/', data)
        self.assertEqual(response.status_code, 201)

    def test_slotparkir_detail_update_delete(self):
        slot = models.SlotParkir.objects.create(slotparkirid='A3', status='UNAVAILABLE')

        response = self.client.get(f'/api/slotparkir/{slot.slotparkirid}/')
        self.assertEqual(response.status_code, 200)

        update = {
            "slotparkirid": "A3",
            "status": "AVAILABLE"
        }
        response = self.client.put(f'/api/slotparkir/{slot.slotparkirid}/', update)
        self.assertEqual(response.status_code, 200)

        response = self.client.delete(f'/api/slotparkir/{slot.slotparkirid}/')
        self.assertEqual(response.status_code, 204)

    def test_update_slot_status(self):
        response = self.client.patch(f'/api/slotparkir/{self.slot.slotparkirid}/status/', {'status': 'UNAVAILABLE'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['status'], 'UNAVAILABLE')

    def test_booking_list_create(self):
        response = self.client.get('/api/booking/')
        self.assertEqual(response.status_code, 200)

        data = {
            "user": self.user.id,
            "slotparkir": self.slot.slotparkirid,
            "tanggal": str(date.today()),
            "status": "ACTIVE",
            "totalharga": 5000
        }
        response = self.client.post('/api/booking/', data)
        self.assertEqual(response.status_code, 201)

    def test_laporan_list_create(self):
        response = self.client.get('/api/laporan/')
        self.assertEqual(response.status_code, 200)

        data = {
            "user": self.user.id,
            "gambar": b"binarydata",
            "lokasi": "Sekitar C3",
            "status": "UNDONE"
        }
        response = self.client.post('/api/laporan/', data)
        self.assertIn(response.status_code, [201, 400])

    def test_update_laporan_status(self):
        laporan = models.Laporan.objects.create(user=self.user, gambar=b"abc", status="UNDONE")
        response = self.client.patch(f'/api/laporan/{laporan.id}/status/', {'status': 'DONE'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['status'], 'DONE')

    def test_notice_list_create(self):
        response = self.client.get('/api/notice/')
        self.assertEqual(response.status_code, 200)

        data = {
            "tanggal": "2025-05-24",
            "event": "Penutupan",
            "judul": "Parkiran Ditutup",
            "description": "Event Rekfest"
        }
        response = self.client.post('/api/notice/', data)
        self.assertEqual(response.status_code, 201)

    def test_tertutup_list_create(self):
        notice = models.Notice.objects.create(tanggal="2025-05-22", event="Penutupan", judul="Parkiran Ditutup")
        response = self.client.get('/api/tertutup/')
        self.assertEqual(response.status_code, 200)

        data = {
            "slotparkir": self.slot.slotparkirid,
            "notice": notice.noticeid
        }
        response = self.client.post('/api/tertutup/', data)
        self.assertEqual(response.status_code, 201)
