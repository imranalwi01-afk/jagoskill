# Jagoskill Shared Hosting Deploy

Panduan ini untuk deploy Laravel app ini ke shared hosting cPanel dengan direktori domain seperti:

- `/home/USERNAME/public_html/jagoskill.com`

## Model yang direkomendasikan

Gunakan seluruh project di dalam folder domain:

- `/home/USERNAME/public_html/jagoskill.com`

Karena file [root `.htaccess`](D:\rocket\.htaccess) sudah mengarahkan request ke folder `public/`, kita tidak perlu memindahkan isi `public` ke luar folder project.

## Struktur target

Di hosting, hasil akhirnya sebaiknya seperti ini:

```text
/home/USERNAME/public_html/jagoskill.com/
  app/
  bootstrap/
  config/
  database/
  lang/
  public/
  resources/
  routes/
  storage/
  vendor/
  .env
  artisan
  composer.json
  .htaccess
```

## File yang wajib ada di hosting

- seluruh source code dari repo
- folder `vendor`
- folder `storage`
- file `.env`

## File yang tidak perlu diunggah manual

- dump database lokal
- log lokal
- file kredensial lokal
- folder arsip/documentation yang sudah diabaikan oleh git

## Opsi deploy

### Opsi A: Git di cPanel

Pakai ini jika menu `Git Version Control` tersedia di cPanel.

1. Clone repo GitHub `jagoskill` lewat menu `Git Version Control`.
2. Arahkan clone ke folder repository terpisah, misalnya:
   `/home/USERNAME/repositories/jagoskill`
3. Pastikan branch yang dipakai adalah `main`.
4. Repo ini sudah menyediakan file [`.cpanel.yml`](D:\rocket\.cpanel.yml) dan script [deploy/cpanel-post-deploy.sh](D:\rocket\deploy\cpanel-post-deploy.sh).
5. Saat tombol `Deploy HEAD Commit` dijalankan di cPanel, source akan disalin ke:
   `$HOME/public_html/jagoskill.com`
6. Buat atau update `.env` production di folder live `jagoskill.com`.
7. Deploy script hanya menyalin source code ke folder live agar proses cPanel tidak mudah stuck.
8. Jalankan Composer dan Artisan secara manual hanya setelah source berhasil mendarat di folder live.

### Opsi B: Upload ZIP dari laptop

Pakai ini jika Git/SSH tidak tersedia.

1. Download source dari GitHub atau buat ZIP dari working tree.
2. Upload ke folder `jagoskill.com`.
3. Extract di File Manager.
4. Upload `vendor` jika Composer tidak bisa dijalankan di hosting.
5. Buat `.env`.

## Environment produksi minimum

Contoh nilai penting:

```env
APP_NAME=Jagoskill
APP_ENV=production
APP_DEBUG=false
APP_URL=https://jagoskill.com

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=YOUR_DB_NAME
DB_USERNAME=YOUR_DB_USER
DB_PASSWORD=YOUR_DB_PASSWORD

QUEUE_CONNECTION=sync
SESSION_DRIVER=file
CACHE_DRIVER=file

MAIL_MAILER=smtp
MAIL_HOST=YOUR_SMTP_HOST
MAIL_PORT=587
MAIL_USERNAME=YOUR_SMTP_USERNAME
MAIL_PASSWORD=YOUR_SMTP_PASSWORD
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=admin@jagoskill.com
MAIL_FROM_NAME="Jagoskill"
```

## Permission yang biasanya dibutuhkan

Set folder ini writable:

- `storage/`
- `bootstrap/cache/`

Permission yang umum:

- folder: `755`
- file: `644`

Jika hosting meminta lebih longgar untuk runtime:

- `storage`: `775`
- `bootstrap/cache`: `775`

## Langkah setelah upload

Jika SSH/Terminal tersedia, jalankan:

```bash
php artisan key:generate
php artisan migrate --force
php artisan optimize:clear
```

Jika `APP_KEY` sudah dibuat di lokal dan ingin dipakai ulang, tidak perlu generate lagi.

Urutan manual yang saya sarankan di hosting:

```bash
cd ~/public_html/jagoskill.com
composer install --no-dev --optimize-autoloader
php artisan optimize:clear
php artisan storage:link
```

## Catatan untuk Git deploy cPanel

- Folder clone repository tidak harus sama dengan folder live domain
- Justru lebih aman jika clone repo berada di luar folder publik/domain
- Folder live yang dipakai saat ini adalah:
  `$HOME/public_html/jagoskill.com`
- File `.env` production harus dibuat langsung di folder live, bukan di repo lokal

## Storage link

Jika fitur upload butuh akses publik ke `storage/app/public`, jalankan:

```bash
php artisan storage:link
```

Jika shared hosting tidak mengizinkan symlink, kita perlu pakai strategi fallback terpisah.

## Cron di shared hosting

Project ini punya route cron berbasis web, jadi untuk jalur hemat bisa pakai cron URL dari hosting.

Contoh pola:

- `https://jagoskill.com/cron-jobs/sendReminder`
- `https://jagoskill.com/cron-jobs/meetingReminder`

Method yang aktif harus disesuaikan dengan controller yang tersedia di project.

## Verifikasi awal

Setelah live, cek ini:

1. halaman depan bisa dibuka
2. login admin normal
3. upload file tidak error
4. email test terkirim
5. forum, course, dan halaman panel tidak `500`
6. `storage/logs/laravel.log` tidak dipenuhi error permission

## Catatan penting

- Repo GitHub sudah aktif sebagai source of truth
- Jangan edit source code langsung di hosting kecuali sangat darurat
- Semua perubahan idealnya dibuat dari laptop lalu dideploy ulang
