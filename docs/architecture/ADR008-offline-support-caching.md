# ADR 008: Offline Support & Caching

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ membutuhkan kemampuan untuk tetap merespons dengan baik meskipun koneksi internet pengguna tidak stabil. Hal ini penting untuk meningkatkan pengalaman pengguna, terutama pada area dengan jaringan terbatas. Oleh karena itu, perlu strategi caching dan offline support yang mempertimbangkan prioritas data real-time, seperti data dari WebSocket, serta data non-kritis yang bisa disimpan sementara di perangkat.

---

## Decision 
Kami memutuskan untuk menerapkan strategi online-first caching, yaitu aplikasi akan selalu mencoba mengambil data terbaru dari server terlebih dahulu. Jika tidak tersedia koneksi internet, aplikasi akan menampilkan data cache lokal untuk beberapa konten tertentu yang relevan. Namun, untuk data yang bersifat real-time dan berbasis WebSocket, seperti status parkir terkini, data tersebut tidak akan ditampilkan saat offline karena akurasinya sangat bergantung pada konektivitas langsung dengan server.

---

## Alternative 
Kami mempertimbangkan tidak menggunakan caching sama sekali atau full online, namun akan mengurangi user experience dalam kondisi jaringan buruk.

---

## Consequences
**Good**:
Responsivitas aplikasi tetap terjaga dalam kondisi online, dengan fallback ringan saat offline serta mengurangi risiko menampilkan informasi real-time yang sudah tidak relevan.



**Bad**:
Tidak semua data dapat disimpan, sehingga pengalaman offline hanya sebagian.


