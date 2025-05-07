# ADR 010: Testing Strategy & CI/CD Pipeline

Status : [**Accepted**]
Date : [**07/05/2025**]

## Context
Aplikasi ParkirKi’ merupakan aplikasi mobile lintas platform yang dikembangkan secara kolaboratif oleh beberapa anggota tim. Untuk menjaga kualitas kode dan meminimalkan regresi, penting untuk menerapkan strategi pengujian otomatis dan memastikan bahwa setiap perubahan kode diuji secara konsisten sebelum digabungkan ke branch utama. Maka dari itu, diperlukan pipeline CI yang dapat menjalankan proses build dan testing secara otomatis setiap kali ada perubahan kode. Namun, saat ini tim belum membutuhkan proses CD (Continuous Deployment) ke Play Store atau App Store karena rilis masih dilakukan secara manual dan tidak terlalu sering.

---

## Decision 
Kami memutuskan untuk menggunakan GitHub Actions sebagai alat Continuous Integration. GitHub Actions menyediakan integrasi langsung dengan repositori GitHub kami, memungkinkan otomatisasi proses build dan pengujian setiap kali ada pull request atau push ke branch tertentu. Hal ini membantu menjaga kualitas kode, mempercepat feedback loop, dan memastikan stabilitas sebelum merge dilakukan.

---

## Alternative 
Tidak menggunakan CI/CD sama sekali.

---

## Consequences
**Good**:
Proses testing dan build otomatis setiap kali terjadi perubahan kode sehingga standar kualitas kode terjaga dan mencegah terjadinya error saat merge.


**Bad**:
Tim belum terbiasa dengan penggunaan Github Actions sebagai proses testing, sehingga masih perlu penyesuaian. Karena tim belum terbiasa, perlu waktu untuk belajar cara mengkonfigurasi workflow. 


