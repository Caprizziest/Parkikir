# 🎯 Frontend – ParkirKi’

Frontend aplikasi **ParkirKi’** dikembangkan menggunakan **Flutter**, dengan arsitektur **MVVM** dan manajemen state menggunakan **Riverpod**. Aplikasi ini dirancang khusus untuk platform **Android**, dengan dukungan fitur real-time, pelaporan pelanggaran parkir, integrasi pembayaran, dan pemantauan status parkir.

---

## 📋 Requirements

Pastikan Anda memiliki perangkat lunak berikut:

### 🧰 Tools

| Tools            | Versi Minimum  | Kegunaan                                                            |
| ---------------- | -------------- | ------------------------------------------------------------------- |
| `Flutter SDK`    | `>=3.5.3`      | Untuk membangun aplikasi Android                                    |
| `Dart SDK`       | Sesuai Flutter | Bahasa pemrograman utama Flutter                                    |
| `Android Studio` | Opsional       | Untuk debugging, emulator, dan build APK                            |
| `build_runner`   | `^2.4.6`       | Untuk generate file secara otomatis (misalnya: model, adapter, dsb) |

### 📦 Dependencies Penting

| Package              | Keterangan                                          |
| -------------------- | --------------------------------------------------- |
| `flutter_riverpod`   | State management utama berbasis provider            |
| `go_router`          | Manajemen rute (navigasi antar halaman)             |
| `sentry_flutter`     | Monitoring error dan crash                          |
| `intl`               | Format waktu, tanggal, dan angka                    |
| `jwt_decoder`        | Dekode token JWT untuk otentikasi                   |
| `shared_preferences` | Penyimpanan data sederhana di perangkat             |
| `url_launcher`       | Membuka tautan eksternal atau aplikasi sistem       |
| `phosphor_flutter`   | Ikon vektor berkualitas tinggi                      |
| `image_picker`       | Akses kamera dan galeri untuk pelaporan pelanggaran |

---

## ✅ Instalasi

Unduh dan siapkan dependensi Flutter

```bash
flutter pub get
```

## 🚀 Menjalankan Aplikasi
Jalankan di emulator atau device Android:
```bash
flutter run
```
Konfigurasi variabel `.env`
Buat file `.env` di direktori root dan isi seperti berikut:

```ini
BASE_URL=http://192.168.1.10:8000
WS_BASE_URL=ws://192.168.1.10:8000/ws/parkiran/
MIDTRANS_CLIENT_KEY=...
```
⚠️ Pastikan `BASE_URL` dan `WS_BASE_URL` mengarah ke IP backend kamu saat diakses melalui Android.

## 🧭 Struktur Folder (Umum)
Folder	Fungsi
| Folder            | Fungsi                                                       |
| ----------------- | ------------------------------------------------------------ |
| `lib/view/`       | UI untuk halaman seperti login, home, booking, laporan, dll. |
| `lib/viewmodel/`  | Logika aplikasi, pemrosesan data, dan pengelolaan API        |
| `lib/model/`      | Struktur data dari API (Slot, Booking, Laporan, dsb)         |
| `lib/services/`   | Fungsi komunikasi REST API dan WebSocket                     |
| `lib/repository/` | Konstanta umum seperti warna, teks, base URL                 |
| `lib/config/`     | Fungsi bantu: validasi, formatting, popup, dll.              |
| `lib/routing/`    | Fungsi menyimpan deklarasi route.                            |

## 🔐 Otentikasi & Manajemen Token
Gunakan JWT (JSON Web Token) untuk login dan autorisasi.

`jwt_decoder` digunakan untuk mengambil data dari token (misalnya ID user, expired, role, dsb).


