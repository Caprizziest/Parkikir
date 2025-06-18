# 🛠️ Backend – ParkirKi’

Backend ini dibangun menggunakan framework **Django** dan menyediakan API serta WebSocket untuk aplikasi ParkirKi’. Backend bertugas menangani otentikasi pengguna, pengelolaan data parkir, laporan pelanggaran, booking slot, serta integrasi dengan sistem pembayaran dan AI detection.

---

## 📋 Requirements

Sebelum menjalankan backend, pastikan semua dependensi berikut terpasang:

### 🔧 Dasar

| Paket                           | Kegunaan                                            |
| ------------------------------- | --------------------------------------------------- |
| `Django`                        | Framework utama backend                             |
| `djangorestframework`           | Untuk membangun REST API                            |
| `djangorestframework-simplejwt` | Autentikasi menggunakan JSON Web Token              |
| `pymysql`                       | Driver koneksi Django ke MySQL                      |
| `django-cors-headers`           | Mengatur Cross-Origin Resource Sharing (CORS)       |
| `channels`, `daphne`            | Mendukung WebSocket (real-time connection)          |
| `drf-yasg`                      | Dokumentasi API otomatis (Swagger UI)               |
| `ultralytics`                   | Integrasi AI untuk deteksi kendaraan                |
| `sentry-sdk[django]`            | Pelacakan error/logging otomatis menggunakan Sentry |

### ✅ Instalasi Semua Sekaligus

```bash
pip install -r requirements.txt
```
Atau satu per satu jika diperlukan:
 ```bash
pip install django
pip install djangorestframework
pip install djangorestframework-simplejwt
pip install pymysql
pip install django-cors-headers
pip install channels daphne
# channels_redis (tidak digunakan saat ini)
pip install ultralytics
pip install drf-yasg
pip install "sentry-sdk[django]"
```

## 🚀 Cara Menjalankan Backend
1. Jalankan Server Django (HTTP)
```bash
python manage.py runserver
```

2. Jalankan Django dengan Daphne (untuk WebSocket)
```bash
python -m daphne -b 0.0.0.0 -p 8000 parkirki.asgi:application
```

## 📌 Jika Anda menggunakan IP lokal untuk testing di perangkat Android, pastikan:

- Tambahkan IP ke ALLOWED_HOSTS di settings.py

- Ubah baseurl dan wsbaseurl di frontend menjadi IP lokal Anda

## 🧱 Migrasi dan Data Awal
Lakukan migrasi database sebelum menjalankan server:

```bash
python manage.py migrate
```

## 📦 AI Bounding Box Configuration (Untuk Kamera Parkir)
Aplikasi ini menggunakan modul dari ultralytics untuk konfigurasi titik parkir (bounding box) secara visual. Jalankan perintah berikut di Python:

```python
from ultralytics import solutions
solutions.ParkingPtsSelection()
```
🧠 Fungsi: membuka antarmuka visual untuk memilih area parkir yang ingin dideteksi oleh kamera.

© 2025 ParkirKi’ Backend – UC Makassar IMT '23