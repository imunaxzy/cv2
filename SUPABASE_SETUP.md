# Setup Owner Login + Ganti Foto Profil

Versi ini memakai **Supabase Auth + Storage**. Supabase menyediakan autentikasi email/password dan penyimpanan file; website memakai `supabase-js` melalui CDN.

## 1. Buat project Supabase

Buka dashboard Supabase dan buat project baru.

## 2. Buat akun owner

Di **Authentication → Users**, buat user dengan:

- Email: `imamaxzy@gmail.com`
- Password: buat password pribadi yang kuat.

Jangan masukkan password ke file HTML.

## 3. Jalankan SQL

Buka **SQL Editor** di project Supabase, lalu jalankan seluruh isi file:

`supabase_setup.sql`

SQL tersebut membuat tabel pengaturan foto, bucket `profile`, serta policy agar hanya akun dengan email owner yang boleh mengunggah/mengganti/menghapus foto.

## 4. Masukkan URL dan publishable key

Di Supabase buka **Project Settings → API**. Salin:

- Project URL
- Publishable key (atau anon key pada project lama)

Kemudian buka `index.html` dan cari:

```js
const SUPABASE_URL='PASTE_YOUR_SUPABASE_URL_HERE';
const SUPABASE_PUBLISHABLE_KEY='PASTE_YOUR_SUPABASE_PUBLISHABLE_KEY_HERE';
```

Ganti kedua placeholder tersebut dengan nilai project kamu.

**Jangan pernah memasukkan `service_role` atau secret key ke `index.html`.**

## 5. Upload ke GitHub

Upload kedua file berikut ke repository yang sama:

- `index.html`
- `supabase_setup.sql` (boleh disimpan sebagai dokumentasi; tidak perlu dijalankan di GitHub)

File `profile.jpg` lama tetap boleh ada sebagai foto cadangan sebelum owner mengunggah foto dari dashboard website.

## 6. Cara kerja setelah aktif

**Pengunjung:**
- Melihat foto profil.
- Tidak melihat tombol `CHANGE PHOTO`.
- Tidak dapat mengganti foto tanpa sesi owner.

**Owner:**
1. Klik `OWNER LOGIN` di footer.
2. Masukkan email dan password Supabase.
3. Setelah login, tombol `CHANGE PHOTO` muncul.
4. Pilih foto dari galeri.
5. Foto dikompres ke WebP dan disimpan ke Supabase Storage.
6. URL foto disimpan di tabel `profile_settings`.
7. Pengunjung berikutnya akan melihat foto baru.

## Catatan penting

GitHub Pages tetap menjadi tempat hosting website, sedangkan Supabase menangani login, authorization, database, dan penyimpanan foto. Ini diperlukan karena HTML/JavaScript statis saja tidak bisa memberikan owner-only security yang sebenarnya.
