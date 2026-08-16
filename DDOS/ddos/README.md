# DDoS — Daily Dose of Software 📱

A Flutter mobile application built as part of the **Excelerate Internship Program**. DDoS is a daily learning app that delivers bite-sized software knowledge through an engaging, structured mobile experience.

---

## 👤 Developer

**Frontend Developer:** Rasool Bux
**Scope:** Flutter Frontend (UI, navigation, local storage, API client)
**Platform:** Android & iOS (Flutter cross-platform)

---

## ✅ Sprint Deliverables

The following tasks were assigned and have been completed as part of the frontend sprint:

---

### 1. 🎬 Splash Screen
- Animated splash screen with staggered **fade-in + slide-up** effects
- Logo and "Excelerate" tagline animate in sequence using native `AnimationController`
- Total on-screen duration: **~2.5 seconds**
- Automatically navigates to the Login screen using `Navigator.pushReplacementNamed`
- Strictly follows the Material 3 app theme via `Theme.of(context).colorScheme`

---

### 2. 🔐 Login & Registration UI with Client-Side Validation
**Files:** `lib/screens/auth/login_screen.dart`, `lib/screens/auth/signup_screen.dart`

- Full **Login Screen** with email and password fields
- Full **Registration Screen** with full name, email, password, and confirm password fields
- Client-side form validation:
  - ✅ Email format check (must contain `@` and `.`)
  - ✅ Password minimum length of **8 characters**
  - ✅ Confirm password match validation
- Password visibility toggle on both screens
- Loading state with spinner while submitting
- Navigation between Login ↔ Sign Up screens

---

### 3. 🔒 Secure JWT Storage + Dio API Client with Auth Interceptors
**Files:** `lib/services/auth_service.dart`, `lib/services/dio_client.dart`

**Secure Storage (`AuthService`):**
- Uses `flutter_secure_storage` to store JWT token under key `jwt_token`
- Methods: `saveToken()`, `getToken()`, `deleteToken()`, `isLoggedIn()`
- JWT payload decoder to extract `userId` from token claims

**Dio Client (`DioClient`):**
- Singleton Dio instance with `baseUrl`, connection and receive timeouts
- **Auth Interceptor (`onRequest`):** Automatically attaches `Authorization: Bearer <token>` header to every API request
- **Error Interceptor (`onError`):** On `401 Unauthorized`, clears token and redirects to `/login` without any manual handling
- Global `NavigatorKey` wired into `MaterialApp` for context-free navigation from service layer

---

### 4. 🏠 Main App Shell — Bottom Navigation Bar
**File:** `lib/screens/main_screen.dart`

- Bottom navigation bar with **5 tabs**: Home, Explore, Daily Dose, Progress, Profile
- `IndexedStack` preserves each tab's scroll position and state
- Active tab highlighted in app primary color (amber)
- Rounded top edge with soft shadow for polished look
- Profile tab wired to the real `ProfileScreen`
- Home, Explore, Daily Dose, and Progress tabs show **"Coming Soon"** placeholder screens (ready for backend integration)

---

### 5. 👤 Profile Screen
**Files:** `lib/screens/profile/profile_screen.dart` and sub-screens

- Displays **Alex Chen** learner profile with avatar, gradient ring, and verified badge
- **Daily Streak counter** — shows streak in days with lightning icon
- **Total Points counter** — shows accumulated points
- Three fully navigable settings tiles:
  - ⭐ **Favorite Topics** → opens `FavoriteTopicsScreen` (Coming Soon)
  - 📥 **Download for Offline** → opens `DownloadOfflineScreen` (Coming Soon)
  - ⚙️ **Account Settings** → opens `AccountSettingsScreen` (Coming Soon)
- Theme toggle switch (Warm Light)
- **Logout action** with confirmation dialog → clears JWT token → redirects to Login
- App version footer

---

## 📁 Project Structure

```
lib/
├── config/                    # App-level configuration (planned)
├── models/                    # Data models (planned — backend integration)
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   └── home_screen.dart   # Coming Soon placeholder
│   ├── explore/               # Coming Soon placeholder
│   ├── feed/                  # Coming Soon placeholder
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── favorite_topics_screen.dart
│   │   ├── download_offline_screen.dart
│   │   └── account_settings_screen.dart
│   ├── splash_screen.dart
│   └── main_screen.dart       # App shell + bottom nav
├── services/
│   ├── auth_service.dart      # JWT secure storage
│   └── dio_client.dart        # HTTP client + interceptors
├── utils/
│   └── constants.dart         # Colors, theme, app-wide constants
├── widgets/                   # Reusable widgets (planned)
└── main.dart                  # App entry point + routes
```

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `flutter_secure_storage` | Secure local JWT token storage |
| `dio` | HTTP client with Auth interceptors |
| `provider` | State management (planned) |
| `shared_preferences` | Lightweight local storage for offline features |
| `intl` | Date and time formatting |
| `flutter_launcher_icons` | Custom app icon generation |

---

## 🚀 How to Run

**Prerequisites:** Flutter SDK, Android Studio or Xcode, a connected device or emulator.

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for Android
flutter build apk
```

---

## 🗺️ What's Coming Next (Backend Integration)

The following screens are built as **"Coming Soon" placeholders**, ready to be filled once the backend API is available:

- 🏠 Home Screen — personalized daily feed
- 🔍 Explore Screen — topic discovery and search
- ⚡ Daily Dose (Feed) Screen — daily software content cards
- 📊 Progress Screen — learning analytics and milestones
- ⭐ Favorite Topics — user's saved topic list
- 📥 Offline Downloads — locally cached content
- ⚙️ Account Settings — profile editing and privacy controls

---

## 🎨 Design System

All colors, typography, spacing, and theme tokens are centralized in `lib/utils/constants.dart`.

| Token | Value | Usage |
|---|---|---|
| Primary | `#D97706` (Golden Amber) | Buttons, active tabs, CTAs |
| Primary Theme | `#8D4B00` (Deep Amber) | Material primary token |
| Background | `#FAF9F8` (Warm off-white) | Screen backgrounds |
| Surface | `#FFFFFF` | Cards, bottom nav |
| Primary Text | `#1A1C1C` | Headings, body text |
| Secondary Text | `#554336` | Captions, hints |

---

*Frontend implementation by Rasool Bux — Excelerate Internship, 2026*
