# 🍞 Roti Pagi Bakery — Sistem Informasi Penggajian dan Insentif

Aplikasi web sederhana untuk membantu administrasi data karyawan, absensi dan lembur, hasil produksi roti, perhitungan insentif, penggajian, slip gaji, serta laporan.

Aplikasi dibuat menggunakan **HTML5, CSS, Vanilla JavaScript, Tailwind CSS CDN, Font Awesome CDN, dan Supabase JavaScript Client v2**. 

## 🔗 Demo Aplikasi

**Demo online:** setelah GitHub Pages aktif, ganti placeholder link berikut dengan URL GitHub Pages milik repository kamu.

[**Buka Demo Roti Pagi Bakery**](https://helenayunita0306.github.io/bakery-payroll-app)

Contoh: jika username GitHub kamu `namakamu` dan repository-nya `bakery-payroll-app`, tautannya menjadi:

`https://namakamu.github.io/bakery-payroll-app/`

> Aplikasi langsung terbuka dalam **Mode Demo** secara default. Mode Demo tidak memerlukan akun, email, password, URL Supabase, maupun API key. Data contoh dikelola di browser menggunakan `localStorage` dan tidak dikirim ke database Supabase.

## ✨ Fitur

- **Dashboard:** ringkasan karyawan, penggajian, insentif, lembur, produksi, dan status penggajian.
- **Data Karyawan:** tambah, lihat, edit, cari, filter, dan hapus/nonaktifkan data karyawan.
- **Absensi & Lembur:** pencatatan kehadiran harian dan jam lembur.
- **Data Produksi:** pencatatan hasil produksi dan jumlah produk yang lolos pemeriksaan kualitas.
- **Insentif Karyawan:** insentif dihitung berdasarkan jumlah produk yang lolos kualitas dikalikan tarif insentif per unit.
- **Penggajian:** perhitungan gaji, tunjangan, lembur, insentif, potongan, dan gaji bersih; status Draft, Disetujui, dan Dibayar.
- **Slip Gaji & Laporan:** melihat dan mencetak slip gaji serta mengekspor rekap ke CSV.
- **Pengaturan:** identitas perusahaan, parameter penggajian, dan tarif insentif produk.
- **Mode Demo dan Supabase:** data demo terpisah dari data database Supabase.

## 🧰 Teknologi

- HTML5
- CSS murni
- Vanilla JavaScript ES6
- Tailwind CSS melalui CDN
- Font Awesome melalui CDN
- Supabase JavaScript Client v2 melalui CDN
- PostgreSQL di Supabase (opsional)

## 📁 Struktur Proyek

```text
bakery-payroll-app/
├── index.html           # Kerangka aplikasi dan pemanggilan CDN
├── style.css            # Tema bakery dan layout responsif
├── app.js               # Navigasi, CRUD UI, perhitungan, demo, laporan
├── supabase-config.js   # Konfigurasi dan operasi database Supabase
├── schema.sql           # Tabel, constraint, indeks, RLS, dan data awal produk
└── README.md            # Dokumentasi proyek
```

## 🚀 Menjalankan Demo di Komputer

1. Unduh ZIP proyek ini dan ekstrak folder `bakery-payroll-app`.
2. Buka VS Code, lalu pilih **File → Open Folder** dan pilih folder tersebut.
3. Jika belum ada, pasang ekstensi **Live Server** di VS Code.
4. Klik kanan `index.html`, lalu pilih **Open with Live Server**.
5. Aplikasi akan terbuka di browser dan mulai dalam **Mode Demo**. Tidak perlu mengisi file `supabase-config.js` untuk mencoba demo.
6. Buka menu di sidebar untuk mencoba data karyawan, absensi, produksi, insentif, penggajian, slip gaji, laporan, dan pengaturan.

### Cara menggunakan Mode Demo

- Label **DEMO** dan pemberitahuan mode demo menunjukkan bahwa aplikasi menggunakan data contoh.
- Demo sudah berisi karyawan, absensi, produksi roti, produk, dan contoh transaksi untuk uji coba.
- Tambahkan, edit, atau hapus data seperti biasa. Perubahan demo akan tersimpan pada browser yang sedang digunakan.
- Untuk mengembalikan data contoh awal, buka **Pengaturan → Reset Data Demo**, lalu konfirmasi. Tindakan ini menghapus perubahan demo di browser tersebut.
- Mode Demo tidak memakai login dan tidak mengakses database Supabase. Data demo tidak otomatis dibagikan dengan pengguna/browser lain.

### Kode untuk membuka demo

Tidak perlu menambahkan kode khusus. `app.js` sudah memuat data demo saat aplikasi dimulai:

```javascript
// Sudah diatur di app.js: demo dimuat saat aplikasi pertama kali dibuka.
async function init() {
  loadDemo();
  // ...inisialisasi navigasi dan komponen aplikasi...
  render();
}

document.addEventListener('DOMContentLoaded', init);
```

Potongan di atas hanya menjelaskan mekanisme yang sudah ada—**jangan menambahkannya lagi** ke `app.js`, karena fungsi inisialisasi sudah tersedia.

## 🌐 Menayangkan Demo di GitHub Pages

Agar orang lain bisa mencoba demo melalui link publik:

1. Buat repository GitHub, misalnya `bakery-payroll-app`.
2. Unggah seluruh file proyek ke **root** repository: `index.html`, `style.css`, `app.js`, `supabase-config.js`, `schema.sql`, dan `README.md`.
3. Buka repository → **Settings → Pages**.
4. Pada **Build and deployment**, pilih **Deploy from a branch**.
5. Pilih branch `main` dan folder `/(root)`, lalu klik **Save**.
6. Tunggu sampai GitHub Pages menampilkan URL situs. Gunakan URL yang diberikan GitHub pada bagian **Demo Aplikasi** di atas.

GitHub Pages hanya meng-host frontend statis. Demo dapat berjalan tanpa Supabase. Pastikan `index.html` berada di root repository agar URL default mengarah ke aplikasi.

## 🗄️ Menghubungkan Supabase (Opsional)

> **Peringatan:** gunakan Mode Demo untuk eksplorasi awal. Sebelum memasukkan data karyawan atau gaji sungguhan, perketat Row Level Security (RLS), otorisasi peran, dan kebijakan akses sesuai kebutuhan organisasi.

1. Buat proyek di [Supabase](https://supabase.com/).
2. Buka **SQL Editor** pada proyek Supabase.
3. Salin seluruh isi `schema.sql`, lalu jalankan skripnya.
4. Buka **Project Settings → API** (atau bagian API Keys di dashboard) dan salin **Project URL** serta **anon/publishable key**.
5. Buka `supabase-config.js`, lalu ganti nilai contoh berikut:

   ```javascript
   const SUPABASE_URL = 'ISI_URL_PROYEK_SUPABASE_ANDA';
   const SUPABASE_ANON_KEY = 'ISI_ANON_PUBLISHABLE_KEY_ANDA';
   ```

   dengan URL proyek dan anon/publishable key milikmu. **Jangan pernah menaruh `service_role` key di frontend atau repository publik.**

6. Di **Authentication → Users**, buat pengguna untuk pengujian.
7. Kembali ke aplikasi. Klik tombol mode di sidebar untuk beralih dari Demo ke Supabase, lalu masuk menggunakan email dan password pengguna tersebut.
8. Untuk kembali ke data demo, gunakan tombol mode dan pilih Mode Demo.

`schema.sql` menyiapkan tabel dan produk awal, tetapi **tidak memasukkan karyawan, absensi, produksi, atau penggajian demo ke database**. Data contoh tersebut hanya dipakai Mode Demo agar tidak tercampur dengan database Supabase.

### Catatan keamanan Supabase

- `anon/publishable key` memang digunakan pada frontend, tetapi keamanan data tetap bergantung pada RLS dan kebijakan akses.
- `schema.sql` adalah konfigurasi awal untuk pengujian. Kebijakan akses tabel saat ini mengizinkan pengguna yang telah terautentikasi mengakses tabel payroll; ini **belum memisahkan izin admin dan staf penggajian**.
- Sebelum digunakan dengan data sensitif, buat dan uji kebijakan RLS yang membatasi akses berdasarkan peran, tinjau semua operasi CRUD, dan jangan menggunakan data pribadi nyata di demo publik.
- Parameter lembur, BPJS, dan PPh Pasal 21 adalah masukan yang harus diverifikasi dan diperbarui sesuai ketentuan resmi serta kondisi masing-masing karyawan. Aplikasi ini bukan pernyataan kepatuhan hukum atau pajak.

## 🧮 Contoh Perhitungan Insentif

Misalnya seorang karyawan memproduksi 1.000 roti manis, dengan 950 unit lolos standar kualitas dan tarif insentif Rp200 per unit:

```text
Insentif = Produk lolos kualitas × Tarif insentif
         = 950 × Rp200
         = Rp190.000
```

Produk yang tidak lolos kualitas tidak dihitung ke insentif berdasarkan rumus tersebut.

## 🧪 Checklist Pengujian Demo

- [ ] Buka Dashboard dan periksa ringkasan data contoh.
- [ ] Tambah karyawan melalui menu Data Karyawan, lalu edit dan hapus/nonaktifkan data uji.
- [ ] Tambah absensi dan jam lembur pada tanggal tertentu.
- [ ] Catat hasil produksi dengan jumlah lolos kualitas tidak melebihi jumlah produksi.
- [ ] Periksa hasil pada menu Insentif Karyawan.
- [ ] Buat penggajian untuk suatu periode dan periksa rincian komponennya.
- [ ] Ubah status penggajian dari Draft ke Disetujui dan Dibayar.
- [ ] Buka slip gaji, gunakan cetak browser, dan uji ekspor laporan CSV.
- [ ] Uji **Pengaturan → Reset Data Demo** untuk mengembalikan data awal.

## 📌 Batasan dan Catatan

- Mode Demo menyimpan perubahan di `localStorage` pada browser/perangkat yang digunakan, bukan pada server pusat.
- Menghapus data browser atau `localStorage` dapat menghapus perubahan demo. Gunakan menu reset untuk memulai dari data contoh awal.
- Mode Supabase membutuhkan proyek dan kredensial sendiri serta kebijakan RLS yang benar.
- Perhitungan pajak, BPJS, dan lembur perlu diverifikasi sebelum digunakan untuk proses penggajian operasional.

## 📄 Lisensi

Tambahkan file lisensi bila proyek ini akan dibagikan atau digunakan kembali secara publik.
