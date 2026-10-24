# 🍞 Roti Pagi Bakery — Sistem Informasi Penggajian dan Insentif

Aplikasi web untuk administrasi data karyawan, absensi dan lembur, hasil produksi roti, perhitungan insentif, penggajian, slip gaji, serta laporan — terhubung langsung ke **Supabase** sebagai database.

Dibuat menggunakan **HTML5, CSS, Vanilla JavaScript, Tailwind CSS CDN, Font Awesome CDN, dan Supabase JavaScript Client v2**.

## 🔗 Akses Aplikasi

**Link aplikasi:**

[**Buka Roti Pagi Bakery Payroll**](https://helenayunita0306-netizen.github.io/Sistem-Penggajian-Pabrik-Roti/)

> Saat dibuka, sistem langsung menampilkan halaman login Supabase. Masukkan email dan password akun yang sudah dibuat di Supabase Authentication.

## ✨ Fitur

- **Dashboard:** ringkasan karyawan, penggajian, insentif, lembur, produksi, dan status penggajian.
- **Data Karyawan:** tambah, lihat, edit, cari, filter, dan hapus/nonaktifkan data karyawan.
- **Absensi & Lembur:** pencatatan kehadiran harian dan jam lembur.
- **Data Produksi:** pencatatan hasil produksi dan jumlah produk yang lolos pemeriksaan kualitas.
- **Insentif Karyawan:** insentif dihitung berdasarkan jumlah produk yang lolos kualitas dikalikan tarif insentif per unit.
- **Penggajian:** perhitungan gaji, tunjangan, lembur, insentif, potongan, dan gaji bersih; status Draft, Disetujui, dan Dibayar.
- **Slip Gaji & Laporan:** melihat dan mencetak slip gaji serta mengekspor rekap ke CSV.
- **Pengaturan:** identitas perusahaan, parameter penggajian, dan tarif insentif produk.

## 🧰 Teknologi

- HTML5
- CSS murni
- Vanilla JavaScript ES6
- Tailwind CSS melalui CDN
- Font Awesome melalui CDN
- Supabase JavaScript Client v2 melalui CDN
- PostgreSQL di Supabase

## 📁 Struktur Proyek

```text
Sistem-Penggajian-Pabrik-Roti/
├── index.html           # Kerangka aplikasi dan pemanggilan CDN
├── style.css            # Tema bakery dan layout responsif
├── app.js               # Navigasi, CRUD UI, perhitungan, dan laporan
├── supabase-config.js   # Konfigurasi dan operasi database Supabase
├── schema.sql           # Tabel, constraint, indeks, RLS, dan data awal produk
└── README.md            # Dokumentasi proyek
```

## 🚀 Menjalankan di Komputer (Lokal)

1. Clone atau unduh ZIP repository ini.
2. Buka VS Code → **File → Open Folder** → pilih folder proyek.
3. Pasang ekstensi **Live Server** jika belum ada.
4. Klik kanan `index.html` → **Open with Live Server**.
5. Browser akan membuka aplikasi dan langsung menampilkan **halaman login Supabase**.
6. Masukkan email dan password akun Supabase kamu, lalu klik **Masuk**.

> Jika ingin mencoba tanpa database, klik **"Gunakan Mode Demo"** di halaman login.

## 🗄️ Pengaturan Supabase

### 1. Buat Proyek Supabase

1. Buka [https://supabase.com](https://supabase.com) dan buat proyek baru.
2. Catat **Project URL** dan **anon/publishable key** dari **Project Settings → API**.

### 2. Jalankan Schema Database

1. Buka **SQL Editor** di dashboard Supabase.
2. Klik **New query**, salin seluruh isi `schema.sql`, lalu klik **Run**.
3. Semua tabel, constraint, RLS, dan data produk awal akan terbuat otomatis.

### 3. Buat Akun Pengguna

1. Di dashboard Supabase → **Authentication → Users**.
2. Klik **Add user → Create new user**.
3. Isi email dan password yang akan digunakan untuk login ke sistem.

### 4. Isi Kredensial di Aplikasi

Buka `supabase-config.js` dan isi dengan URL dan key proyek kamu:

```javascript
const SUPABASE_URL = 'https://xxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJ...';
```

> **Jangan pernah memasukkan `service_role` key di file ini.**

### 5. Login ke Sistem

Buka aplikasi → masukkan email dan password → klik **Masuk**. Sistem akan langsung memuat data dari Supabase dalam **Mode LIVE**.

## 🧮 Contoh Perhitungan Insentif

```text
Insentif = Produk lolos kualitas × Tarif insentif per unit
         = 950 unit × Rp200
         = Rp190.000
```

Produk yang tidak lolos kualitas tidak dihitung ke insentif.

## 🔒 Catatan Keamanan

- `anon/publishable key` memang digunakan di frontend, tetapi keamanan data bergantung pada RLS yang sudah dikonfigurasi di `schema.sql`.
- Kebijakan RLS saat ini mengizinkan semua pengguna yang telah terautentikasi. Perketat sesuai kebutuhan organisasi sebelum digunakan untuk data produksi.
- Parameter lembur, BPJS, dan PPh Pasal 21 harus diverifikasi sesuai ketentuan resmi. Aplikasi ini bukan pernyataan kepatuhan hukum atau pajak.

## 📌 Batasan

- Tidak ada pemisahan peran admin dan staf penggajian pada konfigurasi RLS default.
- Perhitungan pajak, BPJS, dan lembur perlu diverifikasi sebelum digunakan secara operasional.

## 📄 Lisensi

Tambahkan file lisensi bila proyek ini akan dibagikan atau digunakan kembali secara publik.
