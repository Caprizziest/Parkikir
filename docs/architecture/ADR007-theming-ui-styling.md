# ADR 007: Theming & UI Styling

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ merupakan aplikasi mobile yang ditujukan untuk platform Android dan IOS. Penampilan visual yang konsisten dan dapat disesuaikan sangat penting untuk menjaga pengalaman pengguna yang baik di kedua platform.



---

## Decision 
Kami memutuskan untuk menggunakan Flutter’s Material theming sebagai dasar, karena seluruh anggota tim telah terbiasa dengan sistem tersebut melalui pengalaman mengikuti codelabs. Material Design menyediakan komponen UI yang lengkap, dokumentasi yang baik, serta dukungan terhadap kustomisasi. Untuk memperkuat brand identity dan menghindari tampilan yang terlalu default, kami juga melakukan berbagai penyesuaian terhadap elemen-elemen seperti warna, tipografi, bentuk komponen, dan gaya tombol.

---

## Alternative 
Kami mempertimbangkan untuk menggunakan Flutter’s Material secara keseluruhan, karena mengingat waktu, usaha dan kemampuan tim yang terbatas serta dalam mendesain tema aplikasi dengan baik.


---

## Consequences
**Good**:
Dengan menggunakan Flutter’s Material, pekerjaan tim dapat menjadi lebih mudah karena sudah ada komponen Material yang sudah tersedia. Hal ini tentu dapat mendorong tim untuk lebih fokus mendesain fitur aplikasi dibandingkan membangun komponen UI dari awal.

**Neutral**:
Tim perlu lebih berhati-hati saat melakukan kustomisasi agar tampilan UI aplikasi tetap konsisten dan masih enak dilihat oleh user.


