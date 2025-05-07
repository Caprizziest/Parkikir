# ADR 005: Dependency Injection Framework
Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ dikembangkan dengan Flutter dan memiliki sejumlah fitur yang melibatkan manajemen state, seperti autentikasi, pengelolaan lokasi, dan interaksi pengguna. Seiring dengan kompleksitas aplikasi yang meningkat, penting untuk memisahkan proses pembuatan objek dari penggunaannya guna menjaga keterpisahan antar komponen (loose coupling), meningkatkan skalabilitas kode, dan mempermudah proses pengujian unit. Maka dari itu, pemilihan framework dependency injection (DI) menjadi hal penting dalam arsitektur aplikasi.

---

## Decision 
Kami memutuskan untuk tidak menggunakan Dependency Injection Framework.
---

## Alternative 
Kami mempertimbangkan untuk menggunakan Riverpod sebagai Dependency Injection Framework kami dikarenakan Riverpod memungkinkan pendaftaran dan pemanggilan dependensi secara deklaratif tanpa bergantung pada BuildContext. Hal ini membuat proses penyuntikan dependensi lebih terstruktur dan mudah diuji.

---

## Consequences
**Good**:
Tanpa menggunakan DI framework, kompleksitas awal proyek dapat ditekan dan tim dapat lebih fokus menyelesaikan fitur-fitur inti terlebih dahulu.
Keterlibatan langsung dengan inisialisasi objek juga bisa membantu pemahaman tim terhadap alur dependensi dan interaksi antar komponen aplikasi.


**Bad**:
Skalabilitas aplikasi akan menjadi tantangan karena pembuatan dan pengelolaan objek dilakukan secara manual, sehingga menyulitkan pengujian unit dan pemeliharaan kode jangka panjang.
Seiring bertambahnya fitur, kode akan menjadi lebih tightly coupled dan sulit diuji atau di-refactor tanpa merusak bagian lain.

