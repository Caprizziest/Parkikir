# ADR 006:  Navigation & Routing Solution

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ merupakan aplikasi mobile berbasis Flutter yang memiliki beberapa fitur utama seperti peta lokasi parkir, sistem notifikasi, laporan pengguna, serta integrasi dengan halaman login dan dashboard. Aplikasi ini membutuhkan sistem navigasi yang mendukung deep linking, route nesting, serta pola navigasi deklaratif agar struktur dan logika antar layar tetap bersih dan mudah diatur, khususnya saat aplikasi tumbuh menjadi lebih kompleks.


---

## Decision 
Kami memutuskan untuk menggunakan package go_router sebagai solusi navigasi utama. go_router dibangun di atas Navigator 2.0 dan menawarkan API yang lebih sederhana dan deklaratif. Selain itu, go_router secara native mendukung deep linking, URL restoration, guard (redirect), dan nested routing, yang sangat berguna untuk mengelola alur aplikasi ParkirKi’ yang memiliki beberapa lapisan otorisasi dan tampilan bertingkat.

---

## Alternative 
Kami mempertimbangkan AutoRoute dari segi kemudahan dalam membuat sistem navigasi. AutoRoute memiliki fitur mirip go_router, namun lebih berat secara setup awal dan kurang resmi dibanding go_router, yang lebih direkomendasikan dalam ekosistem resmi Flutter.

---

## Consequences
**Good**:
Navigasi menjadi lebih mudah dikelola berkat struktur deklaratif dari go_router yang bersih dan mudah dibaca, sehingga memudahkan tim dalam memahami dan memelihara alur aplikasi. Selain itu, go_router juga mendukung fitur seperti deep linking dan route guard secara bawaan, yang sangat membantu dalam mengimplementasikan logika otentikasi serta navigasi berbasis peran pengguna dengan lebih terstruktur dan aman.

**Neutral**:
Tim harus mempelajari cara kerja go_router lagi dikarenakan tim belum pernah menggunakan package go_router sebelumnya.

**Bad**:
Kustomisasi sangat kompleks (seperti animasi transisi khusus antar route) mungkin membutuhkan workaround atau override default behavior dari go_router.


