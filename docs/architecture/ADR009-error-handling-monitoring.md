# ADR 009: Error Handling & Monitoring

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ merupakan aplikasi mobile lintas platform yang dikembangkan menggunakan Flutter untuk sisi frontend dan Django untuk backend. Karena aplikasi ini beroperasi di lingkungan produksi dan melayani pengguna secara langsung, penting untuk memiliki sistem pemantauan error dan logging yang andal guna mendeteksi bug, crash, dan anomali performa sedini mungkin. Hal ini bertujuan untuk menjaga stabilitas aplikasi, mempercepat proses debugging, dan meningkatkan pengalaman pengguna secara keseluruhan.


---

## Decision 
Kami memutuskan untuk menggunakan sentry karena Sentry memberikan layanan gratis dan mudah digunakan, serta tersedia pada kedua framework yang akan digunakan dalam mengembangkan aplikasi ParkirKi’, yaitu Flutter dan Django. 

---

## Alternative 
Kami mempertimbangkan untuk membuat custom logging yang tentunya akan memberikan kontrol penuh, akan tetapi memerlukan effort besar untuk membangun sistem pemantauan, penyimpanan log, dan notifikasi sendiri, sehingga tidak ideal untuk tim kecil atau dalam tahap pengembangan awal.

---

## Consequences
**Good**:
Dengan menggunakan Sentry, tim mendapatkan manfaat berupa pelaporan error yang otomatis dan real-time, yang sangat membantu dalam mendeteksi dan menangani masalah lebih cepat sebelum berdampak pada pengguna. Integrasi langsung dengan Flutter dan Django membuat proses setup menjadi lebih sederhana dan memastikan error dari sisi frontend maupun backend dapat dimonitor dalam satu sistem terpusat.

**Neutral**:
Tim belum terbiasa dengan penggunaan Sentry sebagai error handling, sehingga masih perlu penyesuaian.



