<div align="center">

<p align="center">
  <img src="https://github.com/Caprizziest/Parkikir/blob/main/Frontend/frontend/assets/logo.png" alt="ParkirKi' Logo" width="300px">
</p>

_Solusi Efisien untuk Parkir Modern_

![last-commit](https://img.shields.io/github/last-commit/Caprizziest/Parkikir?style=flat&logo=git&logoColor=white&color=0080ff)
![repo-top-language](https://img.shields.io/github/languages/top/Caprizziest/Parkikir?style=flat&color=0080ff)
![repo-language-count](https://img.shields.io/github/languages/count/Caprizziest/Parkikir?style=flat&color=0080ff)

_Built with the tools and technologies:_

![JSON](https://img.shields.io/badge/JSON-000000.svg?style=flat&logo=JSON&logoColor=white)
![Markdown](https://img.shields.io/badge/Markdown-000000.svg?style=flat&logo=Markdown&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-F05138.svg?style=flat&logo=Swift&logoColor=white)
![Django](https://img.shields.io/badge/Django-092E20.svg?style=flat&logo=Django&logoColor=white)
![Gradle](https://img.shields.io/badge/Gradle-02303A.svg?style=flat&logo=Gradle&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2.svg?style=flat&logo=Dart&logoColor=white)
![C++](https://img.shields.io/badge/C++-00599C.svg?style=flat&logo=C%2B%2B&logoColor=white)
![XML](https://img.shields.io/badge/XML-005FAD.svg?style=flat&logo=XML&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B.svg?style=flat&logo=Flutter&logoColor=white)
![CMake](https://img.shields.io/badge/CMake-064F8C.svg?style=flat&logo=CMake&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB.svg?style=flat&logo=Python&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF.svg?style=flat&logo=GitHub-Actions&logoColor=white)
![Kotlin](https://img.shields.io/badge/Kotlin-7F52FF.svg?style=flat&logo=Kotlin&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E.svg?style=flat&logo=YAML&logoColor=white)

</div>


ParkirKi’ adalah aplikasi Android berbasis Flutter dengan dukungan backend Django yang dirancang khusus untuk membantu mahasiswa dan staff Universitas Ciputra Makassar dalam menemukan parkir kosong secara real-time, melakukan booking, serta melaporkan pelanggaran parkir secara praktis dan efisien.

---

## 📌 Daftar Isi

- [📌 Daftar Isi](#-daftar-isi)
- [📖 Tentang Proyek](#-tentang-proyek)
- [🚀 Fitur Utama](#-fitur-utama)
- [🛠 Teknologi yang Digunakan](#-teknologi-yang-digunakan)
  - [Frontend](#frontend)
  - [Backend](#backend)
- [🏛️ Arsitektur Sistem](#️-arsitektur-sistem)
- [⚙️ Instalasi \& Setup](#️-instalasi--setup)
- [🔎 Lebih lanjut](#-lebih-lanjut)
- [👥 Tim Pengembang](#-tim-pengembang)

---

## 📖 Tentang Proyek

**ParkirKi’** dibangun untuk menyelesaikan masalah utama di Universitas Ciputra Makassar, yaitu:

- Sulitnya menemukan slot parkir di jam sibuk.
- Tidak adanya sistem pelaporan pelanggaran parkir yang efisien.
- Kebutuhan akan sistem pemesanan dan pengelolaan parkiran yang terintegrasi.

Target pengguna:

- **Mahasiswa/Staff UC Makassar**: melihat slot parkir real-time, melakukan booking, dan mengirim laporan pelanggaran.
- **Satpam/BMA**: menerima laporan dan mengelola notifikasi parkiran (misalnya, penutupan untuk event).

---

## 🚀 Fitur Utama

- 🔐 **Registrasi & Login** via email institusi.
- 📍 **Slot Parkir Real-time** dengan informasi status AVAILABLE / UNAVAILABLE.
- 📸 **Pelaporan Pelanggaran**: kirim foto + lokasi + keterangan.
- 🗓️ **Booking Slot** parkir untuk jangka waktu tertentu.
- 🔔 **Notifikasi Event** saat area parkir ditutup.
- 💳 **Pembayaran Booking** via Midtrans.

---

## 🛠 Teknologi yang Digunakan

### Frontend
- **Flutter** dengan **Riverpod** untuk manajemen state.
- **MVVM**: arsitektur pemisah antara tampilan, data, dan logika.

### Backend
- **Django** + **Django REST Framework**: API backend.
- **Django Channels**: WebSocket untuk realtime update.
- **MySQL**: database utama.
- **MVC**: arsitektur backend.
- **Midtrans API**: pembayaran.
- **Sentry**: monitoring bug/error.
- **GitHub Actions**: otomatisasi testing & build.

---

## 🏛️ Arsitektur Sistem

ParkirKi’ menggunakan arsitektur client-server. Frontend (Flutter) berkomunikasi dengan backend (Django) melalui REST API dan WebSocket.

- **MVVM di frontend**: memisahkan tampilan (View), logika presentasi (ViewModel), dan data (Model).
- **MVC di backend**: Model (logika data), View (respon data), Controller (alur kontrol API).

---

## ⚙️ Instalasi & Setup

- **[Backend (Django)](Backend/README.md)**
- **[Frontend (Flutter)](Frontend/README.md)**

---

## 🔎 Lebih lanjut
- **[Miro Board](https://miro.com/app/board/uXjVIGQvfNw=/?share_link_id=741279228190)**
- **[Canva Poster](https://www.canva.com/design/DAGqh2viEr0/ixKX79Sk9LK34j9LlHy0QQ/edit?utm_content=DAGqh2viEr0&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)**

---

## 👥 Tim Pengembang
**© ParkirKi’ Team - UC Makassar IMT '23**
- **[Jason Bintang Setiawan](https://github.com/Caprizziest) - 0806022310011**
- **[Aaron Jevon Benedict Kongdoh](https://github.com/trfyrt) - 0806022310014**
- **[Deny Wahyudi Asaloei](https://github.com/denywa) - 0806022310009**
