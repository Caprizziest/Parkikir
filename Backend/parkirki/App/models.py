from django.db import models

# Create your models here.
class User(models.Model):
    username = models.CharField(max_length=45)
    password = models.CharField(max_length=45)
    email = models.CharField(max_length=45)
    role = models.CharField(max_length=45)