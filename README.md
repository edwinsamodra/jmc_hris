# Nuxt 4 + Tabler Admin Dashboard Boilerplate

Boilerplate admin dashboard menggunakan **Nuxt 4** dengan **Tabler UI v1.0.0-beta24**.

## URL Aplikasi & Environment

- **Production URL:** [https://hris.edwinlab.my.id](https://hris.edwinlab.my.id)
- **Production API Docs:** [https://hris.edwinlab.my.id/api-docs](https://hris.edwinlab.my.id/api-docs)
- **Local Development:** [http://localhost:3000](http://localhost:3000)

---

## Prasyarat Lingkungan Development (Dev Prerequisites)

Pastikan mesin lokal Anda telah terpasang:
- **Node.js:** `v20.x` atau `v22.x` / `v24.x` (LTS direkomendasikan)
- **Package Manager:** `npm` (v10+)
- **Docker & Docker Compose:** Untuk menjalankan MariaDB lokal

---

## Panduan Setup Development (Local Dev)

Ikuti langkah-langkah berikut untuk memulai development:

### 1. Salin Environment Template & Konfigurasi `.env`

Salin file `.env.example` ke `.env`:

```bash
cp .env.example .env
```

Untuk development lokal standar, file `.env` sudah terisi nilai default yang siap pakai:
```dotenv
APP_NAME="HRIS JMC"
APP_CLIENT="JMC"
TZ="Asia/Jakarta"

DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=jmc_hris
DB_USER=admin
DB_PASSWORD=jamurkembang
```
> **Catatan:** Jika Anda membutuhkan fitur login Google OAuth, kirim email/OTP asli, atau reCAPTCHA live, lengkapi `CLIENT_ID`, `MAIL_USER`, dan `RECAPTCHA_*` di `.env`. Untuk mode simulasi lokal, nilai default sudah cukup.

---

### 2. Jalankan Database MariaDB (via Docker)

Jalankan container MariaDB di background:

```bash
docker compose up -d mariadb
```
*Tabel skema ([init.sql](file:///Users/edwinsamodra/Code/jmc_hris/server/database/init.sql)) dan data seed awal ([seed.sql](file:///Users/edwinsamodra/Code/jmc_hris/server/database/seed.sql)) otomatis diimpor saat container pertama kali dibuat.*

Untuk memastikan container aktif:
```bash
docker compose ps
```

---

### 3. Install Dependencies & Jalankan Dev Server

```bash
# Install dependencies
npm install

# Jalankan Nuxt 4 development server (hot-reload aktif)
npm run dev
```

Buka antarmuka aplikasi di [http://localhost:3000](http://localhost:3000).

---

## Opsi: Menjalankan Full Stack via Docker

Jika ingin menjalankan aplikasi Nuxt beserta MariaDB di dalam container tanpa perlu menginstall Node.js di host:

```bash
# Build dan jalankan seluruh container
docker compose up -d --build

# Melihat log container
docker compose logs -f

# Menghentikan container
docker compose down
```

---

## Perintah Pengembangan yang Sering Digunakan

| Perintah | Kegunaan |
| :--- | :--- |
| `npm run dev` | Menjalankan server development lokal dengan hot-reload |
| `npm run build` | Melakukan compile aplikasi untuk production (`.output`) |
| `npm run preview` | Menjalankan preview dari build production secara lokal |
| `docker compose up -d mariadb` | Menyalakan service database MariaDB |
| `docker compose stop mariadb` | Menghentikan service database MariaDB |
| `docker compose exec mariadb mariadb -uadmin -pjamurkembang jmc_hris` | Membuka interactive MariaDB CLI |
| `curl http://localhost:3000/api/health` | Memeriksa status kesehatan API & koneksi database |

---


## Dokumentasi API & Swagger UI

Aplikasi dilengkapi dengan antarmuka Swagger UI interaktif untuk melihat dan menguji endpoint API backend:

- **Swagger UI:** [http://localhost:3000/api-docs](http://localhost:3000/api-docs)
- **OpenAPI JSON Spec:** [http://localhost:3000/api/openapi](http://localhost:3000/api/openapi)

### Cara Menguji Endpoint di Swagger UI:
1. Akses [http://localhost:3000/api-docs](http://localhost:3000/api-docs) pada browser.
2. Pilih salah satu endpoint yang ingin diuji (misal: `GET /api/employees`).
3. Klik tombol **Try it out**.
4. Isi parameter jika diperlukan, kemudian klik tombol **Execute** untuk melihat respon data secara langsung.

---

## Kredensial Akun Berdasarkan Role

Berikut akun bawaan (seed data) yang dapat digunakan untuk login ke sistem:

| Role | Identifier (Username / Email / HP) | Password | Akses & Wewenang |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `superadmin`<br>`edwinsamodra@gmail.com`<br>`+6281234567800` | `Boleh@123` | Akses penuh seluruh modul (User & Role Management, Master Data, dll.) |
| **Manager HRD** | `manager.hrd`<br>`manager.hrd@example.com`<br>`+6281234567801` | `Boleh@123` | Modul Pegawai, Presensi, Approval & Laporan Tunjangan Transport |
| **Admin HRD** | `admin.hrd`<br>`admin.hrd@example.com`<br>`+6281234567802` | `Boleh@123` | Pengelolaan Pegawai, Entry/Import Presensi, Setup Tarif & Periode Tunjangan |

> **Catatan OTP:** Kode OTP 4-digit akan langsung ditampilkan di kotak preview kuning (Mode Simulasi) dan tercatat pada log terminal server.

---

## Konfigurasi Menu Sidebar

Edit `app/data/menu.js` untuk menambah/mengubah/menghapus menu:

```js
export const menuItems = [
  {
    title: "Dashboard",
    icon: IconLayoutDashboardFilled, // Tabler Icons
    to: "/",
  },
  {
    title: "Menu dengan Submenu",
    icon: IconUserFilled,
    children: [
      // Array children = dropdown menu
      { title: "Submenu 1", to: "/menu/sub1" },
      { title: "Submenu 2", to: "/menu/sub2" },
    ],
  },
];
```

Tabler Icons bisa dilihat di: https://tabler.io/icons

---

## Dark Mode

Dark mode otomatis tersimpan di `localStorage`. Toggle tersedia di navbar kanan atas.

Implementasi via composable `useTheme()`:

```js
const { isDark, toggleTheme, initTheme } = useTheme();
```

---

## Menambah Halaman Baru

1. Buat file di `app/pages/nama-halaman/index.vue`
2. Tambahkan `definePageMeta({ title: 'Judul Halaman' })`
3. Tambahkan menu di `app/data/menu.js`

```vue
<template>
  <div>
    <!-- konten halaman -->
  </div>
</template>

<script setup>
definePageMeta({
  title: "Halaman Baru",
});
</script>
```
