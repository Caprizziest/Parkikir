# ADR 004: Local Data Persistence

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ memiliki fitur yang memerlukan penyimpanan data lokal seperti status parkir terakhir yang dilihat pengguna, cache hasil pencarian lokasi parkir, serta log aktivitas pengguna untuk debugging. Karena aplikasi akan digunakan di berbagai situasi jaringan (termasuk saat offline), diperlukan sistem penyimpanan lokal yang cepat, ringan, dan mampu menyimpan objek kompleks dengan efisien.


---

## Decision 
Kami memutuskan untuk menggunakan ObjectBox pada Flutter sebagai solusi local data persistence untuk aplikasi ParkirKi’. ObjectBox menawarkan performa tinggi, penyimpanan berbasis objek yang efisien, serta API yang mudah digunakan


---

## Alternative 
Kami mempertimbangkan untuk menggunakan SQLite karena cocok untuk struktur data relasional, namun memerlukan lebih banyak boilerplate dan setup untuk integrasi dan query.


---

## Consequences
**Good**:
Penyimpanan dan pengambilan data sangat cepat dan efisien.

**Neutral**:
Seluruh tim belum terbiasa menggunakan package objectbox sehingga masih perlu penyesuaian.


**Bad**:
Dokumentasi ObjectBox belum sebesar SQLite atau alternatif lainnya, sehingga troubleshooting mungkin lebih menantang bagi tim.

