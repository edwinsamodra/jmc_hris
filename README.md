# Nuxt 4 + Tabler Admin Dashboard Boilerplate

Boilerplate admin dashboard menggunakan **Nuxt 4** dengan **Tabler UI v1.0.0-beta24**.

## Memulai

### 1. Install dependencies

```bash
npm install
```

### 2. Konfigurasi `.env`

Edit `.env` untuk mengatur nama aplikasi dan nama client:

```bash
APP_NAME=NAME_APP_HERE
APP_CLIENT=NAME_CLIENT_HERE
```

### 3. Jalankan development server

```bash
npm run dev
```

Buka [http://localhost:3000](http://localhost:3000)

### 4. Menjalankan via Docker Compose (Rekomendasi)

```bash
# Jalankan App dan MariaDB container
docker compose up -d --build
```

### 5. Build untuk production

```bash
npm run build
```

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
