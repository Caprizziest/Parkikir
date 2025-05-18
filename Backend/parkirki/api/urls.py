from django.urls import path
from .views import *

urlpatterns = [
    path('users/', getData, name='get_users'),
    path('register/', register, name='register'),
    path('login/', login, name='login'),

    path('slotparkir/', slotparkir_list_create, name='slotparkir-list-create'),
    path('slotparkir/<str:pk>/', slotparkir_detail, name='slotparkir-detail'),
    path('slotparkir/<str:pk>/status/', update_slot_status, name='slotparkir-update-status'),

    path('booking/', booking_list_create, name='booking-list-create'),
    path('booking/<int:pk>/', booking_detail, name='booking-detail'),

    path('laporan/', laporan_list_create, name='laporan-list-create'),
    path('laporan/<int:pk>/status/', update_laporan_status, name='laporan-update-status'),

    path('notice/', notice_list_create, name='notice-list-create'),
    path('tertutup/', tertutup_list_create, name='tertutup-list-create'),
]
