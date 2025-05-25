from django.test import SimpleTestCase
from django.urls import reverse, resolve
import api.views as views

class TestUrls(SimpleTestCase):

    def test_urls_get_users(self):
        url = reverse('get_users')
        self.assertEqual(resolve(url).func, views.getData)

    def test_urls_register(self):
        url = reverse('register')
        self.assertEqual(resolve(url).func, views.register)

    def test_urls_login(self):
        url = reverse('login')
        self.assertEqual(resolve(url).func, views.login)
        
    def test_urls_logout(self):
        url = reverse('logout')
        self.assertEqual(resolve(url).func, views.logout)

    def test_urls_slotparkir_list_create(self):
        url = reverse('slotparkir-list-create')
        self.assertEqual(resolve(url).func, views.slotparkir_list_create)

    def test_urls_slotparkir_detail(self):
        url = reverse('slotparkir-detail', args=['A1'])
        self.assertEqual(resolve(url).func, views.slotparkir_detail)

    def test_urls_update_slot_status(self):
        url = reverse('slotparkir-update-status', args=['A2'])
        self.assertEqual(resolve(url).func, views.update_slot_status)

    def test_urls_booking_list_create(self):
        url = reverse('booking-list-create')
        self.assertEqual(resolve(url).func, views.booking_list_create)

    def test_urls_booking_detail(self):
        url = reverse('booking-detail', args=[1])
        self.assertEqual(resolve(url).func, views.booking_detail)

    def test_urls_laporan_list_create(self):
        url = reverse('laporan-list-create')
        self.assertEqual(resolve(url).func, views.laporan_list_create)

    def test_urls_update_laporan_status(self):
        url = reverse('laporan-update-status', args=[1])
        self.assertEqual(resolve(url).func, views.update_laporan_status)

    def test_urls_notice_list_create(self):
        url = reverse('notice-list-create')
        self.assertEqual(resolve(url).func, views.notice_list_create)

    def test_urls_tertutup_list_create(self):
        url = reverse('tertutup-list-create')
        self.assertEqual(resolve(url).func, views.tertutup_list_create)
