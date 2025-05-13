from django.urls import path
from .views import *

urlpatterns = [
    path('users/', getData, name='get_users'),
    path('register/', register, name='register'),
    path('login/', login, name='login'),
]
