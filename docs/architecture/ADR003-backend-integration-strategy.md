# ADR 003: Backend Integration Strategy

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ akan menangani data yang terus berubah seperti status slot parkir secara real-time, identifikasi pelanggaran, dan notifikasi kepada pengguna. Untuk menjaga keteraturan struktur kode dan memudahkan kolaborasi dalam tim yang relatif kecil, diperlukan strategi integrasi backend yang sederhana namun fleksibel, memiliki performa baik, dan dapat mempercepat proses pengembangan.


---

## Decision 
Kami memutuskan untuk menggunakan RESTful API sebagai penghubung utama antara front-end dan back-end. Setiap komponen utama seperti status slot parkir, pelaporan pelanggaran, dan notifikasi akan memiliki endpoint CRUD tersendiri, dan ditambah endpoint WebSocket untuk pembaruan data secara real-time. Pendekatan ini memudahkan front-end dalam mengakses data secara terstruktur, mudah disimpan sementara (cache), dan kompatibel dengan hampir semua library HTTP atau real-time di berbagai platform.



---

## Alternative 
Pertimbangan pertama kami adalah GraphQL, yang menawarkan fleksibilitas query dan penggabungan beberapa resource dalam satu request. Namun, kompleksitas setup server dan kebutuhan caching yang lebih spesifik dirasa berlebihan untuk skala awal ParkirKi’. Alternatif lain adalah Backend-as-a-Service (misalnya Firebase), yang akan mempercepat prototyping berkat realtime database bawaan dan otentikasi terintegrasi. Namun, ketergantungan vendor dan terbatasnya kustomisasi logika bisnis di sisi server membuat opsi ini kurang ideal untuk kebutuhan pengolah pelanggaran dan aturan spesifik kami.

---

## Consequences
**Good**:
Dengan menggunakan RESTful API, tim akan lebih mudah menguji setiap endpoint secara terpisah serta dokumentasi API juga lebih mudah dibuat (misalnya dengan Swagger/OpenAPI). Selain itu, seluruh anggota tim sudah terbiasa dalam membangun RESTful API berdasarkan pengalaman proyek sebelumnya, sehingga pendekatan ini dapat menghemat waktu pengembangan dan meminimalkan kebutuhan pelatihan tambahan. Di sisi performa, penggunaan WebSocket terpisah untuk update real-time memastikan payload JSON pada REST tidak menumpuk. 

**Bad**:
Tim perlu menyiapkan infrastruktur caching (Redis atau HTTP cache) agar tidak membebani database dengan polling berulang, serta memastikan konsistensi antara state real-time dan state REST.

