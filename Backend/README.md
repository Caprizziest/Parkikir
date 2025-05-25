# Backend
Backend
Run on Django

### Requirement:
- Install all run
```pip install -r requirements.txt```

- Django
```pip install django```

- Django Rest Framework
```pip install djangorestframework```

- Json Web Token (JWT)
```pip install djangorestframework-simplejwt```

- MySQL connection
```pip install pymysql```

- Django Channels
```pip install channels```
```pip install daphne```
```pip install channels_redis``` **(Not Used for now)**

- Swagger
```pip install drf-yasg```

- [Sentry error tracking](https://sentry.io/)
```pip install "sentry-sdk[django]"```

### Run:
```python manage.py runserver```
```python -m daphne parkirki.asgi:application``` **(For Django Channels)**

### Migrate:
```python manage.py migrate```
```python manage.py seed_slotparkir```
