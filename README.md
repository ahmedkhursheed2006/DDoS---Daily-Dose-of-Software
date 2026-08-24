# DDoS — Daily Dose of Software 📱

A Flutter mobile application built as part of the **Excelerate Internship Program**. DDoS is a daily learning app that delivers bite-sized software knowledge through an engaging, structured mobile experience.

---

## 👤 Developer

**Frontend Developer:** Rasool Bux
**Scope:** Flutter Frontend, UI, navigation, secure local storage, API client, and T5 authentication integration
**Platform:** Android & iOS (Flutter cross-platform)

---

## ✅ Sprint Deliverables

The assigned frontend and authentication work has been completed, including integration with the T5 authentication API. The implementation follows the project's SDD architecture and preserves the existing UI and functionality.

---

## 📅 Weekly Changes & Deliverables

### Summary of What Changed This Week:
1. **API & JSON Connection:** Connected Program Listing (`ExploreScreen`, `HomeScreen`) and Program Details (`PostDetailScreen`) to live API endpoints (`/api/series`, `/api/posts/:id`) with fallback to 32 curated local JSON/Markdown program lessons in `ContentRepository`.
2. **Interactive Forms & Client Validation:**
   - **Registration Form (`SignupScreen`):** Full Name, Email, Password, Confirm Password with live validation (non-empty email, valid format with `@` & `.`, password >= 8 characters, password match check).
   - **Login Form (`LoginScreen`):** Validated login flow connected to JWT authentication.
   - **Feedback/Comment Form (`PostDetailScreen`):** Real-time community feedback & technical comment posting.
   - **Repost Form (`ExploreScreen`):** Modal dialog with optional commentary for sharing posts.
3. **Loading States & Error Handling:** Added smooth `CircularProgressIndicator` loading spinners, pull-to-refresh indicators, Dio exception handling for network timeouts/HTTP status codes, floating error SnackBars, retry views, and offline fallback support.
4. **Documentation:** Created [CHANGELOG_DOCUMENTATION.md](file:///d:/DDoS%20-%20Daily%20Dose%20of%20Software/DDoS---Daily-Dose-of-Software/CHANGELOG_DOCUMENTATION.md) summarizing the weekly updates.

---

### 1. 🎬 Splash Screen

* Animated splash screen with staggered **fade-in + slide-up** effects
* Logo and "Excelerate" tagline animate in sequence using native `AnimationController`
* Total on-screen duration: **~2.5 seconds**
* Automatically navigates to the Login screen
* Uses the existing Material 3 theme and centralized theme configuration

---

### 2. 🔐 Login & Registration

**Files:**

* `lib/screens/auth/login_screen.dart`
* `lib/screens/auth/signup_screen.dart`

#### Login

* Email and password fields
* Client-side email validation
* Minimum 8-character password validation
* Password visibility toggle
* Loading state
* User-friendly backend/network error messages
* Real API authentication through `AuthService.login()`
* Connects to **`POST /auth/login`**

#### Registration

* Full Name, Email, Password, and Confirm Password fields
* Client-side validation
* Password confirmation matching
* Independent password visibility toggles
* Loading state
* User-friendly backend/network error messages
* Real API registration through `AuthService.register()`
* Connects to **`POST /auth/register`**

The existing UI, styling, validation, and navigation were preserved while replacing the previous mock authentication flow with real API integration.

---

### 3. 🔒 Secure JWT Storage & API Client

**Files:**

* `lib/services/auth_service.dart`
* `lib/services/dio_client.dart`
* `lib/models/user.dart`
* `lib/utils/constants.dart`

#### AuthService

* Uses `flutter_secure_storage`
* Stores JWT under `jwt_token`
* Stores authenticated user data under `user_data`
* Provides token retrieval and deletion
* Provides `login()` and `register()` authentication methods
* Provides `logout()` to clear authentication data
* Provides JWT user ID decoding

#### DioClient

* Centralized Dio HTTP client
* Uses the configured backend API URL
* Connection and receive timeouts
* Automatically attaches:
  `Authorization: Bearer <token>`
* Handles HTTP `401 Unauthorized`
* Clears authentication and redirects to Login on unauthorized requests

#### API Configuration

Current Android Emulator URL:

```text
http://10.0.2.2:3000/api
```

For other environments:

```text
Physical Device: http://<your-machine-LAN-IP>:3000/api
iOS Simulator / Web: http://localhost:3000/api
```

---

### 4. 🏠 Main App Shell & Bottom Navigation

**File:** `lib/screens/main_screen.dart`

* 5 bottom navigation tabs:

  * Home
  * Explore
  * Daily Dose
  * Progress
  * Profile
* Uses `IndexedStack` to preserve tab state
* Active tab uses the application's amber theme
* Rounded top edge and subtle shadow
* **Home tab is now connected to the existing `HomeScreen`**
* Profile tab is connected to the completed `ProfileScreen`
* Remaining feature tabs currently contain placeholders for future tasks

---

### 5. 👤 Profile Screen

**Files:**

* `lib/screens/profile/profile_screen.dart`
* `lib/screens/profile/favorite_topics_screen.dart`
* `lib/screens/profile/download_offline_screen.dart`
* `lib/screens/profile/account_settings_screen.dart`

The Profile area is fully implemented for the current T1 scope.

#### Profile Header

* User avatar
* Gradient ring
* Verification badge
* Display name
* Member-since information

#### Stats

* **Daily Streak**
* **Total Points**

#### 🔥 Streak Badges

A horizontal badge section containing:

* **7-Day Flame** 🔥
* **30-Day Master** 🏆
* **Fast Learner** ⚡
* **Bug Hunter** 🐛

An earned-badge count is also displayed.

#### 🔖 Saved Posts

A saved/bookmarked software-learning post section containing:

* Post title
* Topic/tag
* Reading time
* Bookmark action/toggle

Current sample posts include:

* Understanding Async/Await in Dart & Flutter
* SOLID Principles Simplified for Junior Developers
* REST vs GraphQL: Key Differences & When to Use Which

#### Settings

* Favorite Topics
* Download for Offline
* Theme
* Account Settings

#### Logout

* Confirmation dialog
* Clears JWT and stored user data through `AuthService.logout()`
* Redirects to Login

---

## 🔗 6. T5 Backend Authentication Integration

The Flutter authentication layer is integrated with the T5-provided backend API contract.

### Integrated endpoints

| Endpoint         | Method | Purpose                    |
| ---------------- | ------ | -------------------------- |
| `/auth/login`    | `POST` | Authenticate existing user |
| `/auth/register` | `POST` | Create new user account    |

### Login payload

```json
{
  "email": "...",
  "password": "..."
}
```

### Registration payload

```json
{
  "name": "...",
  "email": "...",
  "password": "..."
}
```

### Expected authentication response

```json
{
  "data": {
    "token": "<JWT>",
    "user": {
      "id": "...",
      "name": "...",
      "email": "...",
      "role": "...",
      "streakDays": 0,
      "conceptsMastered": 0,
      "accuracy": 0
    }
  }
}
```

### Authentication flow

```text
Login / Signup
      ↓
AuthService
      ↓
POST /auth/login
or
POST /auth/register
      ↓
JWT + User
      ↓
Secure Storage
      ↓
Authenticated App
```

For authenticated API requests:

```text
DioClient
   ↓
Read JWT
   ↓
Authorization: Bearer <token>
   ↓
Backend API
```

A `401 Unauthorized` response clears the authentication state and redirects the user back to Login.

---

## 📁 Project Structure

The Flutter project follows the SDD-aligned structure:

```text
lib/
├── models/
│   └── user.dart
│
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── explore/
│   ├── feed/
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── favorite_topics_screen.dart
│   │   ├── download_offline_screen.dart
│   │   └── account_settings_screen.dart
│   ├── splash_screen.dart
│   └── main_screen.dart
│
├── services/
│   ├── auth_service.dart
│   └── dio_client.dart
│
├── utils/
│   └── constants.dart
│
├── widgets/
│
└── main.dart
```

The Flutter client communicates with the backend through the API/service layer and does not access the database directly.

---

## 📦 Key Dependencies

| Package                  | Purpose                                     |
| ------------------------ | ------------------------------------------- |
| `flutter_secure_storage` | Secure JWT and user-data storage            |
| `dio`                    | HTTP client and authentication interceptors |
| `shared_preferences`     | Lightweight local storage where required    |
| `intl`                   | Date/time formatting                        |
| `flutter_launcher_icons` | Custom application icon                     |

No new dependencies were required for the T5 authentication integration.

---

## 🎨 Design System

All major colors, typography, spacing, and theme values remain centralized in:

`lib/utils/constants.dart`

| Token          | Value     | Usage                      |
| -------------- | --------- | -------------------------- |
| Primary        | `#D97706` | Buttons, active tabs, CTAs |
| Primary Theme  | `#8D4B00` | Material primary token     |
| Background     | `#FAF9F8` | Screen backgrounds         |
| Surface        | `#FFFFFF` | Cards and navigation       |
| Primary Text   | `#1A1C1C` | Headings and body text     |
| Secondary Text | `#554336` | Captions and hints         |

Existing UI design was preserved during the backend integration.

---

## 🚀 How to Run

### Prerequisites

* Flutter SDK
* Android Studio or Xcode
* Android Emulator / iOS Simulator or physical device
* Node.js backend available for end-to-end authentication testing

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Build Android APK

```bash
flutter build apk
```

---

## 🧪 Verification Status

### Flutter implementation

✅ Login UI and validation
✅ Signup UI and validation
✅ Secure JWT storage
✅ JWT authorization interceptor
✅ 401 handling
✅ Bottom navigation
✅ Profile Screen
✅ Streak Badges
✅ Saved Posts
✅ Logout flow
✅ T5 API integration code
✅ SDD-aligned Flutter structure
✅ `flutter analyze` — **No issues found**

---

## 🗺️ Future Features

The following areas remain outside the current T1 scope and are ready for future implementation/backend integration:

* 🏠 Personalized Home feed
* 🔍 Explore and topic discovery
* ⚡ Daily Dose content feed
* 📊 Progress and learning analytics
* ⭐ Dynamic favorite topics
* 📥 Offline downloads
* ⚙️ Account profile editing and privacy controls
* Dynamic backend-driven streaks, badges, points, and saved posts

---

## ✅ Current T1 Status

**T1 — Rasool Bux: Implementation Complete**

All six assigned T1 deliverables have been implemented, including the authentication UI, secure JWT handling, navigation, Profile Screen, Streak Badges, Saved Posts, and T5 authentication API integration.

The project currently passes `flutter analyze` with **no issues**.

---

*Frontend implementation and T1 integration by Rasool Bux — Excelerate Internship, 2026*
