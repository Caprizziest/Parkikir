# ADR 002: State Management Approach

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ membutuhkan state management yang sederhana namun tetap terstruktur untuk menangani data realtime seperti status slot parkir, identifikasi pelanggaran, dan notifikasi, serta mendukung pemisahan tanggung jawab dalam pengembangan oleh tim kecil.


---

## Decision 
Kami memutuskan untuk menggunakan Riverpod sebagai state-management solution ParkirKi’. Hal ini karena Riverpod  mendukung seluruh jenis async termasuk WebSocket dari back-end.

---

## Alternative 
Kami mempertimbangkan untuk menggunakan Providers, yang dimana merupakan alternatif yang jauh lebih simpel jika dibandingkan dengan BLoC sehingga cocok untuk aplikasi yang dirancang oleh tim kecil.

---

## Consequences
**Good**:
Mendukung semua jenis async.
Modular dan scalable.


**Bad**:
Terlalu panjang.


