# Adibasa App
Aplikasi belajar Bahasa Jawa, dengan metode gamifikasi, latihan interaktif, dan pembelajaran bertahap. Dibuat menggunakan Flutter oleh tim A2 PdBL PENS D4 Teknik Informatika 2023.

# 🧠 Git Workflow

Panduan ini dibuat untuk tim pengembang yang baru mulai menggunakan Git secara kolaboratif dalam proyek Agile. Cocok untuk pemula, namun tetap mengikuti praktik standar industri.

---

## 📌 Konvensi Umum Git

### 📂 Struktur Branch

| Jenis Branch | Format Nama          | Keterangan                                      |
|--------------|----------------------|-------------------------------------------------|
| `main`       | `main`               | Branch utama, biasanya untuk rilis produksi     |
| Development  | `dev`                | Branch integrasi pengembangan                   |
| Fitur        | `feat/*`             | Untuk pengembangan fitur baru                   |

---

## 🔄 Alur Kerja Harian

### 1. 🔻 Clone Repository

```bash
git clone https://github.com/nayzzilar/adibasa_app.git
cd adibasa_app
```

*Mengapa?*  
– **Clone** diperlukan untuk mendapatkan salinan lokal dari repository remote, sehingga kamu bisa mulai bekerja dengan codebase yang sama seperti tim.

---

### 2. 🔀 Checkout (ganti) ke Branch `dev`

```bash
git checkout dev
git pull origin dev
```

*Mengapa?*  
– **Checkout** ke `dev` memastikan kamu bekerja pada branch integrasi terbaru.  
– **Pull** mengambil perubahan terbaru dari remote agar kamu tidak bekerja di atas versi usang.

---

### 3. 🌱 Buat Branch Fitur

```bash
git checkout -b feat/nama-fitur

# atau
git branch feat/nama-fitur
git checkout feat/nama-fitur
```

Contoh:

```bash
git checkout -b feat/login-page

# atau
git branch feat/login-page
git checkout feat/login-page
```

*Mengapa?*  
– Membuat **branch fitur** memisahkan pekerjaanmu dari branch utama, sehingga perubahan bisa di-review dan diuji tanpa mengganggu pengembangan lain.

---

### 4. 🛠️ Tambah Perubahan & Commit

```bash
git add .
git commit -m "feat: tambahkan form login dasar"
```

#### ✅ Format Commit Message:

```text
<type>: <deskripsi singkat>
```

Contoh:
- `feat: tambahkan validasi pada form login`
- `fix: perbaiki error saat login gagal`
- `refactor: ubah struktur folder auth`

*Mengapa?*  
– `git add` memilih file yang akan dimasukkan ke commit, menjaga kontrol atas perubahan.  
– `git commit` membuat snapshot perubahan dengan pesan yang jelas, memudahkan penelusuran riwayat.

---

### 5. 🔄 Rebase dari `dev` (Sebelum Push)

```bash
git fetch origin
git rebase origin/dev
```

*Mengapa?*  
– **Fetch** mengunduh perubahan terbaru tanpa langsung menggabungkannya.  
– **Rebase** memindahkan basis branch fitur ke ujung `dev` yang paling baru, menjaga riwayat linear dan meminimalkan konflik saat merge.

---

### 6. 🚀 Push ke Remote

```bash
git push origin feat/nama-fitur
```

Contoh:

```bash
git push origin feat/login-page
```

*Mengapa?*  
– **Push** mengirim branch fitur ke remote untuk dibagikan dengan tim dan memicu pipeline CI/CD jika tersedia.

---

### 7. ✅ Buat Pull Request (PR)

- **Dari**: `feat/nama-fitur`  
- **Ke**: `dev`  
- **Judul**: `feat: halaman login dasar`  
- **Deskripsi**: Jelaskan fitur, referensi ticket/task jika ada  

*Mengapa?*  
– Pull Request memfasilitasi code review, diskusi, dan validasi otomatis sebelum perubahan digabungkan.

---

### 8. 🔍 Review & Merge (untuk PO)

- Lakukan code review antar tim  
- Gunakan metode **Squash and Merge** untuk merapikan commit history  
- Hapus branch setelah merge (opsional tapi disarankan)  

*Mengapa?*  
– **Code review** meningkatkan kualitas kode dan berbagi pengetahuan.  
– **Squash and Merge** menghasilkan satu commit bersih di `dev`, menjaga riwayat lebih ringkas.  
– Menghapus branch fitur mencegah penumpukan branch usang.

---

## 💡 Perintah Tambahan Git

### 🔍 Lihat Status

```bash
git status
```

*Mengapa?*  
– Menampilkan file yang sudah diubah, belum di-add, atau siap di-commit.

---

### 🕰️ Lihat Riwayat Commit

```bash
git log --oneline --graph --all
```

*Mengapa?*  
– Melihat gambaran riwayat commit dengan visualisasi cabang dan merge.

---

### ❌ Batalkan Commit Terakhir (belum push)

```bash
git reset --soft HEAD~1
```

*Mengapa?*  
– Membatalkan commit terakhir namun tetap menyimpan perubahan di staging, memungkinkan perbaikan pesan atau penyesuaian.

---

## ✅ Contoh Flow Lengkap Developer

```bash
git clone https://github.com/nayzzilar/adibasa_app.git
cd adibasa_app

# Mulai dari branch dev
git checkout dev
git pull origin dev

# Buat dan pindah ke branch fitur
git checkout -b feat/user-profile

# Edit code...
git add .
git commit -m "feat: tambahkan halaman profil pengguna"

# Sinkronisasi dengan dev terbaru
git fetch origin
git rebase origin/dev

# Kirim ke remote
git push origin feat/user-profile
```

