from django.urls import path
import api.views as views

urlpatterns = [
    path('users/', views.getData, name='get_users'),
    path('register/', views.register, name='register'),
    path('login/', views.login, name='login'),

    path('slotparkir/', views.slotparkir_list_create, name='slotparkir-list-create'),
    path('slotparkir/<str:pk>/', views.slotparkir_detail, name='slotparkir-detail'),
    path('slotparkir/<str:pk>/status/', views.update_slot_status, name='slotparkir-update-status'),

    path('booking/', views.booking_list_create, name='booking-list-create'),
    path('booking/<int:pk>/', views.booking_detail, name='booking-detail'),

    path('laporan/', views.laporan_list_create, name='laporan-list-create'),
    path('laporan/<int:pk>/status/', views.update_laporan_status, name='laporan-update-status'),

    path('notice/', views.notice_list_create, name='notice-list-create'),
    path('tertutup/', views.tertutup_list_create, name='tertutup-list-create'),
]
