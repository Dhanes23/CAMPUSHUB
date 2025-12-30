# 🎓 CampusHub - Platform Informasi Kampus Terpadu

<div align="center">

![CampusHub Logo](assets/images/campushubfix.png)

**Platform informasi kampus yang modern dan terpadu untuk mahasiswa dan administrator**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Features](#-fitur-utama) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Installation](#-instalasi) • [Usage](#-penggunaan)

</div>

---

## 📋 Deskripsi

CampusHub adalah aplikasi mobile dan web yang dirancang untuk memudahkan mahasiswa dan administrator dalam mengakses dan mengelola informasi kampus. Dengan desain modern dan interface yang responsif, CampusHub menyediakan satu platform terpadu untuk semua kebutuhan informasi akademik.

## ✨ Fitur Utama

### 👨‍🎓 Untuk Mahasiswa

#### 🏠 Dashboard Interaktif
- Quick access cards untuk navigasi cepat
- Tampilan terkini events, announcements, dan informasi akademik
- Interface modern dengan Material 3 design
- Responsive layout untuk web dan mobile

#### 📅 Manajemen Events
- Browse dan cari events kampus
- Filter berdasarkan kategori (Seminar, Workshop, Kuliah Tamu, dll)
- Detail lengkap event dengan tanggal, lokasi, dan deskripsi
- Registrasi event langsung dari aplikasi

#### 📢 Pengumuman Kampus
- Timeline pengumuman terbaru
- Kategori berdasarkan prioritas (High, Normal, Low)
- Notifikasi untuk pengumuman penting
- Search dan filter pengumuman

#### 📚 Informasi Akademik
- Jadwal kuliah dan ujian
- Informasi deadline tugas
- Kalender akademik
- Announcement dari dosen dan fakultas

#### 💼 Job Board
- Browse lowongan pekerjaan dan magang
- Filter berdasarkan tipe (Full-time, Part-time, Internship, Freelance)
- Detail perusahaan dan deskripsi pekerjaan
- Apply langsung melalui link yang disediakan

#### 👤 Profile Management
- Edit profile pribadi (nama, email, foto)
- Update informasi akademik (NIM, jurusan, tahun angkatan)
- Change password
- Riwayat aktivitas

---

### 👨‍💼 Untuk Administrator

#### 📊 Admin Dashboard
- **Statistik Real-time**: 
  - Total mahasiswa terdaftar
  - Jumlah events aktif
  - Total pengumuman
  - Lowongan pekerjaan tersedia
- **Responsive Grid Layout**: Optimal untuk desktop (4 kolom) dan mobile (2 kolom)
- **Quick Actions**: Akses cepat ke semua fitur manajemen

#### 👥 Manajemen Mahasiswa
- **CRUD Operations**: Create, Read, Update, Delete data mahasiswa
- **Search & Filter**: Cari berdasarkan nama atau NIM
- **Detail View**: Informasi lengkap mahasiswa
- **Bulk Actions**: Update multiple students
- **Responsive Grid**: 1-3 kolom tergantung ukuran layar

#### 🎪 Manajemen Events
- Create event baru dengan detail lengkap
- Edit informasi event yang sudah ada
- Delete events yang tidak diperlukan
- Upload gambar event
- Set kategori dan tanggal
- Responsive card layout

#### 📣 Manajemen Announcements
- Buat pengumuman dengan priority level
- Rich text editor untuk konten
- Schedule pengumuman
- Archive pengumuman lama
- 2-column grid untuk desktop, single column untuk mobile

#### 🎓 Manajemen Akademik
- Upload jadwal kuliah
- Set deadline tugas dan ujian
- Informasi kalender akademik
- Notifikasi otomatis ke mahasiswa

#### 💼 Manajemen Job Listings
- Post lowongan pekerjaan
- Edit detail job listing
- Set tipe pekerjaan (Full-time, Part-time, Internship, Freelance)
- Informasi perusahaan
- Contact information

---

## 🎨 Desain & UI/UX

### Material 3 Design System
- Modern gradient themes
- Consistent color palette
- Beautiful card designs dengan shadows dan elevations
- Smooth animations dan transitions

### Responsive Layout
- **Desktop (≥1200px)**: 
  - Max content width 1400px
  - 4-column stat grids
  - 3-column content grids
  - 40px padding
- **Tablet (600-1200px)**:
  - 3-column stat grids
  - 2-3 column content grids
  - 24px padding
- **Mobile (<600px)**:
  - 2-column stat grids
  - Single-column lists
  - 16px padding

### Custom Components
- Gradient stat cards
- Interactive menu cards
- Modern SliverAppBar dengan FlexibleSpaceBar
- Custom search bars
- Info chips dan badges

---

## 🛠 Tech Stack

### Frontend
- **Framework**: Flutter 3.9.2
- **Language**: Dart
- **UI**: Material 3 Design
- **Fonts**: Google Fonts (customizable)

### Backend & Services
- **Authentication**: Firebase Authentication
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage (untuk images)

### State Management
- **Riverpod 2.5.1**: Modern reactive state management
- **StreamProvider**: Real-time data updates
- **FutureProvider**: Async data handling

### Routing
- **go_router 14.6.2**: Declarative routing
- **Deep linking support**
- **Navigation guards**

### Additional Packages
```yaml
dependencies:
  # Core
  flutter_riverpod: ^2.5.1
  go_router: ^14.6.2
  
  # Firebase
  firebase_core: ^3.10.0
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.6.12
  
  # Utils
  intl: ^0.19.0          # Date formatting
  uuid: ^4.5.1           # Unique IDs
  google_fonts: ^6.3.3   # Custom fonts
  url_launcher: ^6.3.2   # External links
```

---

## 📂 Struktur Project

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # Color palette
│   │   └── app_images.dart      # Image assets
│   └── utils/
│       └── responsive_layout.dart # Responsive helper functions
│
├── models/
│   ├── user_model.dart          # User data structure
│   ├── event_model.dart         # Event data structure
│   ├── announcement_model.dart  # Announcement data
│   ├── academic_info_model.dart # Academic info data
│   └── job_model.dart           # Job listing data
│
├── services/
│   ├── auth_service.dart        # Authentication logic
│   ├── user_service.dart        # User CRUD operations
│   ├── event_service.dart       # Event management
│   ├── announcement_service.dart
│   ├── academic_service.dart
│   └── job_service.dart
│
├── providers/
│   ├── auth_provider.dart       # Auth state management
│   └── feature_providers.dart   # Feature-specific providers
│
├── features/
│   ├── auth/                    # Login, Register, Splash
│   ├── dashboard/               # Student dashboard
│   ├── events/                  # Event list & details
│   ├── announcements/           # Announcement timeline
│   ├── academic/                # Academic info
│   ├── jobs/                    # Job listings
│   ├── profile/                 # User profile
│   └── admin/                   # Admin features
│       ├── admin_dashboard.dart
│       ├── manage_students.dart
│       ├── manage_events.dart
│       ├── manage_announcements.dart
│       ├── manage_academic.dart
│       ├── manage_jobs.dart
│       └── forms/               # CRUD forms
│
└── main.dart                    # App entry point
```

---

## 🚀 Instalasi

### Prerequisites
- Flutter SDK (≥3.9.2)
- Dart SDK
- VS Code
- Firebase account
- Git

### Setup Steps

1. **Clone Repository**
```bash
git clone https://github.com/Dhanes23/CAMPUSHUB.git
cd campushub
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Buat project baru di [Firebase Console](https://console.firebase.google.com)
   - Download `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS)
   - Letakkan di folder yang sesuai:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Enable Firebase Services**
   - Authentication (Email/Password)
   - Cloud Firestore
   - Firebase Storage (optional)

5. **Configure Firestore Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId || 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Public read, admin write for content
    match /{collection}/{document} {
      allow read: if request.auth != null;
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

6. **Run Application**

**For Web:**
```bash
flutter run -d chrome
# atau untuk web server
flutter run -d web-server --web-port=8000
```

**For Android:**
```bash
flutter run -d <device-id>
```

**For iOS:**
```bash
flutter run -d <ios-device-id>
```

---

## 📱 Penggunaan

### Untuk Mahasiswa

1. **Register/Login**
   - Buka aplikasi
   - Pilih "Register" untuk akun baru atau "Login" untuk existing user
   - Isi email dan password

2. **Explore Dashboard**
   - Lihat quick access cards
   - Browse recent events dan announcements
   - Akses informasi akademik

3. **Browse Content**
   - Events: Lihat dan cari events kampus
   - Announcements: Baca pengumuman terbaru
   - Academic: Cek jadwal dan deadline
   - Jobs: Cari lowongan pekerjaan

4. **Update Profile**
   - Klik icon profile
   - Edit informasi pribadi
   - Update foto profile
   - Change password jika diperlukan

### Untuk Admin

1. **Login as Admin**
   - Login dengan akun admin (role: 'admin')
   - Akses admin dashboard

2. **Manage Students**
   - View semua mahasiswa
   - Search berdasarkan nama/NIM
   - Edit detail mahasiswa
   - Delete user jika diperlukan

3. **Manage Content**
   - **Events**: Create, edit, delete events
   - **Announcements**: Post pengumuman dengan priority
   - **Academic**: Upload jadwal dan deadline
   - **Jobs**: Post lowongan pekerjaan

4. **Monitor Statistics**
   - Dashboard menampilkan real-time stats
   - Total students, events, announcements, jobs

---

## 🎯 Roadmap

- [ ] Push notifications untuk announcements
- [ ] Email notifications
- [ ] File upload untuk tugas
- [ ] Chat/messaging system
- [ ] Calendar integration
- [ ] Export data (PDF, Excel)
- [ ] Multi-language support
- [ ] Dark mode
- [ ] PWA support untuk web
- [ ] Attendance tracking

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Dhanes23**
- GitHub: [@Dhanes23](https://github.com/Dhanes23)
- Repository: [CAMPUSHUB](https://github.com/Dhanes23/CAMPUSHUB)

---

## 🙏 Acknowledgments

- Flutter Team untuk framework yang amazing
- Firebase untuk backend services
- Material Design untuk design guidelines
- Community contributors

---

## 📞 Support

Jika ada pertanyaan atau issue, silakan:
- Open an issue di [GitHub Issues](https://github.com/Dhanes23/CAMPUSHUB/issues)
- Contact via GitHub

---

<div align="center">

**Made with ❤️ using Flutter**

⭐ Star repo ini jika bermanfaat!

</div>
