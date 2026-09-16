# HRIS API Boilerplate

API sederhana ini memakai server handler bawaan Nuxt/Nitro dan MariaDB `pj1`.

## Dokumentasi Swagger

Jalankan aplikasi dengan `npm run dev`, lalu buka:

- Swagger UI: `http://localhost:3000/api-docs`
- OpenAPI JSON: `http://localhost:3000/api/openapi`

Swagger UI menyediakan tombol **Try it out** untuk mencoba endpoint secara
langsung. Aset antarmuka Swagger dimuat dari jsDelivr.

## Menjalankan seed

```bash
docker exec -i mariadb mariadb -uadmin -p pj1 < server/database/seed.sql
```

Password akan diminta oleh client. Seed memakai upsert sehingga aman dijalankan
lebih dari sekali.

## Endpoint

| Method | Endpoint | Kegunaan |
| --- | --- | --- |
| GET | `/api/health` | Memeriksa status API |
| GET | `/api/dashboard` | Ringkasan dashboard HRIS |
| GET | `/api/employees` | Daftar pegawai |
| GET | `/api/employees/:id` | Detail pegawai |
| POST | `/api/employees` | Menambah pegawai sementara |
| GET | `/api/departments` | Daftar departemen |
| GET | `/api/attendances?date=YYYY-MM-DD` | Daftar/filter absensi |

Contoh pemakaian di halaman Vue:

```vue
<script setup>
const { data: employees } = await useFetch("/api/employees");
</script>
```

Untuk pengembangan berikutnya, tambahkan autentikasi dan validasi yang lebih
lengkap sesuai kebutuhan aplikasi.
