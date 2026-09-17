# Database HRIS

Proyek ini menggunakan MariaDB yang berjalan dalam container Docker.

## Kredensial

| Konfigurasi | Nilai |
| --- | --- |
| Container Name | `hris-mariadb` (service: `mariadb`) |
| Host dari komputer lokal | `127.0.0.1` |
| Port | `3306` |
| Database | `jmc_hris` |
| Username | `admin` |
| Password | `jamurkembang` |

> Kredensial ini digunakan untuk development lokal. Jangan gunakan kredensial
> yang sama untuk production atau menyimpan password production di repository.

## Memastikan container berjalan

```bash
docker compose ps
# atau
docker ps --filter name=hris-mariadb
```

Jika container belum berjalan, jalankan via Docker Compose:

```bash
docker compose up -d mariadb
```

## Masuk ke MariaDB

Gunakan client `mariadb` di dalam container melalui `docker compose`:

```bash
docker compose exec -it mariadb mariadb -uadmin -p jmc_hris
```

Masukkan password berikut saat diminta:

```text
jamurkembang
```

Untuk koneksi langsung tanpa prompt password:

```bash
docker compose exec -it mariadb mariadb -uadmin -pjamurkembang jmc_hris
```

## Menjalankan query satu kali

Contoh memeriksa tabel yang tersedia:

```bash
docker compose exec mariadb mariadb -uadmin -pjamurkembang jmc_hris -e "SHOW TABLES;"
```

Contoh memeriksa koneksi dan versi MariaDB:

```bash
docker compose exec mariadb mariadb -uadmin -pjamurkembang jmc_hris -e "SELECT DATABASE(), VERSION();"
```

## Konfigurasi aplikasi Nuxt

Tambahkan konfigurasi berikut ke file `.env`:

```dotenv
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=jmc_hris
DB_USER=admin
DB_PASSWORD=jamurkembang
```

Konfigurasi tersebut digunakan jika aplikasi Nuxt dijalankan langsung dari
komputer lokal dengan `npm run dev`.

Jika aplikasi Nuxt dijalankan full di container Docker via `docker compose up`,
`docker-compose.yml` akan otomatis mengarahkan koneksi ke internal host `mariadb`.

## Menjalankan seed HRIS

Saat container pertama kali dibuat (`docker compose up`), file `server/database/init.sql` dan `server/database/seed.sql` sudah otomatis dieksekusi.

Jika ingin menjalankan ulang seed secara manual:

```bash
docker compose exec -i mariadb mariadb -uadmin -pjamurkembang jmc_hris < server/database/seed.sql
```

Seed menggunakan upsert sehingga dapat dijalankan kembali tanpa membuat data
pegawai, departemen, jabatan, wilayah, dan absensi yang sama secara berulang.

## Memeriksa hasil seed

```bash
docker compose exec mariadb mariadb -uadmin -pjamurkembang jmc_hris -e \
  "SELECT id, nip, name, employment_type, status FROM employees;"
```

Health check dari aplikasi juga dapat digunakan setelah Nuxt berjalan:

```bash
curl http://localhost:3000/api/health
```

Respons yang diharapkan:

```json
{
  "status": "ok",
  "service": "hris-api",
  "database": "connected"
}
```

