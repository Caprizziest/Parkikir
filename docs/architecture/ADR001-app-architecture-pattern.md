# ADR 001: App Architecture Pattern

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ akan menangani data yang terus berubah seperti status slot parkir real-time, identifikasi pelanggaran, dan notifikasi. Untuk menjaga keteraturan struktur kode dan memudahkan kolaborasi tim kecil, dibutuhkan pola arsitektur yang sederhana namun tetap memisahkan tanggung jawab utama dalam pengembangan aplikasi.

---

## Decision 
Kami memutuskan untuk menggunakan arsitektur MVVM pada front-end dan MVT atau MVC untuk back-end. Hal ini dilakukan karena mengingat aplikasi ParkirKi’ akan memiliki fitur yang membutuhkan komunikasi real-time. MVVM akan membuat sistem realtime menjadi lebih efektif dibandingkan dengan arsitektur lainnya.

---

## Alternative 
Kami sangat mempertimbangkan untuk menggunakan MVC pada kedua arsitektur aplikasi (Front-end dan back-end). Hal ini karena MVC merupakan arsitektur yang cukup simpel dan telah dipahami oleh seluruh anggota tim.

---

## Consequences
**Good**:
MVVM sangat cocok untuk fitur real-time (seperti melihat slot parkir kosong secara langsung). Tampilan di layar bisa otomatis berubah saat datanya berubah sehingga menjadi lebih efisien dan menjadi alasan utama kami memilihnya.

**Bad**:
Karena tim belum berpengalaman dengan MVVM, kami perlu waktu tambahan untuk mempelajari arsitektur ini, sehingga pada fase awal pengembangan kecepatan pengerjaan kemungkinan akan sedikit menurun.


