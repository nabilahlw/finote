# 💰 Finote — Finance Note App

Aplikasi pencatat keuangan pribadi berbasis Flutter yang terhubung dengan Firebase. Dirancang untuk membantu pengguna memantau pemasukan, pengeluaran, dan saldo secara real-time.

---

## 🗂️ Struktur Proyek

```
finote/
├── lib/
│   ├── main.dart                        # Entry point, inisialisasi Firebase & GetX
│   ├── firebase_options.dart            # Konfigurasi Firebase per platform
│   ├── data/
│   │   ├── auth_repo.dart               # Autentikasi Firebase (login, signup, logout)
│   │   ├── data_services.dart           # Service Firebase Firestore
│   │   ├── login_controller.dart        # Controller GetX untuk login & signup
│   │   ├── add_repo.dart                # Repository tambah transaksi
│   │   ├── transaction_repo.dart        # Repository data transaksi
│   │   ├── transaction_controller.dart  # Controller transaksi
│   │   ├── user_repo.dart               # Repository data user
│   │   └── model/
│   │       ├── user_model.dart          # Model data user
│   │       ├── transaction_model.dart   # Model data transaksi
│   │       └── add_model.dart           # Model tambah transaksi
│   ├── screen/
│   │   ├── login.dart                   # Halaman login & signup
│   │   ├── home.dart                    # Halaman utama (dashboard)
│   │   ├── add.dart                     # Halaman tambah transaksi
│   │   ├── statistic.dart               # Halaman statistik keuangan
│   │   └── wallet.dart                  # Halaman dompet/saldo
│   └── widget/
│       ├── bottomnavigationbar.dart     # Navigation bar bawah
│       └── chart.dart                   # Widget grafik
```

---

## ✨ Fitur

- **Autentikasi** — Register dan login menggunakan Firebase Auth
- **Dashboard** — Tampilan total saldo, pemasukan, dan pengeluaran
- **Tambah Transaksi** — Catat transaksi income dan expense
- **Riwayat Transaksi** — Lihat semua transaksi yang pernah dicatat
- **Statistik** — Grafik visualisasi keuangan
- **Dompet** — Manajemen saldo per kategori
- **Real-time** — Data tersinkron langsung dengan Firebase Firestore

---

## 🛠️ Tech Stack

| Teknologi | Kegunaan |
|-----------|----------|
| Flutter | Framework UI cross-platform |
| Dart | Bahasa pemrograman |
| Firebase Auth | Autentikasi pengguna |
| Cloud Firestore | Database real-time |
| GetX | State management & routing |
| flutter_secure_storage | Penyimpanan data sensitif |

---

## ⚙️ Prasyarat Menjalankan Proyek ini :

Sebelum menjalankan proyek ini, pastikan sudah terinstall:

- [Flutter SDK 3.44.0+](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio)
- [Java JDK 17+](https://www.oracle.com/java/technologies/downloads/)
- Akun [Firebase](https://console.firebase.google.com/)
- Git

## 🚀 Cara Menjalankan Proyek

### 1. Clone Repository

```bash
git clone <url-repository>
cd finote
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Konfigurasi Firebase

Pastikan file berikut sudah ada di proyek:

- `lib/firebase_options.dart` — konfigurasi Firebase
- `android/app/google-services.json` — untuk Android
- `ios/Runner/GoogleService-Info.plist` — untuk iOS

Jika belum ada, ikuti langkah setup Firebase:

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login ke Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Konfigurasi Firebase ke proyek
flutterfire configure
```

### 4. Jalankan Emulator

Buka Android Studio → **Device Manager** → klik **▶ Play** pada emulator.

### 5. Jalankan Aplikasi

```bash
flutter run
```
---

## 🧪 Tutorial Testing

### A. Testing Manual (UI Testing)

| No | Test | Langkah | ✅ Berhasil jika |
|----|------|---------|----------------|
| 1 | **Sign Up** | Buka app → scroll ke bawah → klik **Sign Up** → isi Username, Email, Password (min. 6 karakter) → klik **Sign Up** | Masuk ke halaman Home |
| 2 | **Login** | Sign out → isi email & password terdaftar → klik **Login** | Masuk ke Home dengan nama user |
| 3 | **Tambah Transaksi** | Klik **+** di pojok kanan bawah → pilih Income/Expense → isi jumlah, kategori, deskripsi → **Simpan** | Transaksi muncul di Transactions History |
| 4 | **Statistik** | Klik tab **Statistik** di navigation bar | Grafik menampilkan data transaksi |
| 5 | **Logout** | Klik menu/profil → **Sign Out** | Kembali ke halaman Login |

### B. Testing Firebase Connection

#### Cek Data di Firestore

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project **finote-db**
3. Klik **Firestore Database**
4. ✅ Data user dan transaksi harus muncul setelah Sign Up dan tambah transaksi

#### Cek Autentikasi

1. Di Firebase Console → **Authentication** → **Users**
2. ✅ Akun yang didaftarkan harus muncul di sini


## 📱 Platform yang Didukung

- ✅ Android
- ✅ iOS (membutuhkan Xcode)
- ✅ Web
- ✅ macOS

---
