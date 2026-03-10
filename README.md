
# todo-list-app-firebase
===========================
# ✅ TodoBloc — Flutter To-Do App

A robust, production-ready To-Do List app built with **Flutter**, **Firebase Authentication**, **Firebase Realtime Database**, and **BLoC** state management following clean architecture principles.



## 📱 Features

- **Firebase Email/Password Authentication** — Sign up, log in, password reset
- **Google Sign-In** — One-tap authentication via Google
- **Full Task CRUD** — Create, Read, Update, Delete tasks
- **Toggle Completion** — Mark tasks done/undone with optimistic UI updates
- **Task Priorities** — High / Medium / Low with color coding
- **Due Dates** — Set and track deadlines with overdue indicators
- **Filter Tasks** — View All / Active / Completed tasks
- **Firebase Realtime Database** — All tasks persisted via REST API
- **Dark Mode** — Full system-aware light & dark theme support
- **Responsive UI** — Adapts to any screen size or orientation
- **Swipe Actions** — Slide to edit or delete tasks
- **Smooth Animations** — FadeIn/slide transitions throughout

---

## 🏗️ Architecture — Clean Architecture + BLoC

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       # Firebase URLs, keys, priority values
│   │   └── app_strings.dart         # All UI string constants
│   ├── errors/
│   │   └── failures.dart            # Failure types
│   ├── theme/
│   │   └── app_theme.dart           # Light & Dark MaterialTheme
│   └── utils/
│       ├── date_formatter.dart      # Date display + overdue logic
│       └── validators.dart          # Form validation helpers
│
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart   # Firebase Auth wrapper
│   │   └── task_remote_datasource.dart   # Firebase RTDB REST calls
│   ├── models/
│   │   ├── task_model.dart               # Task JSON serialization
│   │   └── user_model.dart               # User JSON serialization
│   └── repositories/
│       ├── auth_repository_impl.dart     # Auth repo implementation
│       └── task_repository_impl.dart     # Task repo implementation
│
├── domain/
│   ├── entities/
│   │   ├── task.dart                # Task entity (Equatable)
│   │   └── user_entity.dart         # User entity (Equatable)
│   └── repositories/
│       ├── auth_repository.dart     # Auth abstract interface
│       └── task_repository.dart     # Task abstract interface
│
├── presentation/
│   ├── auth/
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart       # Auth BLoC
│   │   │   ├── auth_event.dart      # Auth events
│   │   │   └── auth_state.dart      # Auth states
│   │   ├── pages/
│   │   │   ├── login_page.dart      # Login screen
│   │   │   └── signup_page.dart     # Registration screen
│   │   └── widgets/
│   │       ├── auth_text_field.dart      # Reusable input field
│   │       └── google_sign_in_button.dart
│   ├── splash/
│   │   └── splash_page.dart         # Animated splash screen
│   └── tasks/
│       ├── bloc/
│       │   ├── task_bloc.dart        # Task BLoC
│       │   ├── task_event.dart       # Task events
│       │   └── task_state.dart       # Task states
│       ├── pages/
│       │   └── tasks_page.dart       # Main task list screen
│       └── widgets/
│           ├── add_edit_task_sheet.dart   # Bottom sheet form
│           ├── task_filter_chip.dart      # Filter chips
│           ├── task_list_item.dart        # Swipeable task card
│           └── tasks_header.dart         # Stats summary widget
│
├── firebase_options.dart            # Firebase config (replace with yours)
└── main.dart                        # App entry + DI + BlocProviders
```

---

## 🔷 BLoC State Management

### AuthBloc
| Event | Description |
|-------|-------------|
| `AuthStarted` | Subscribes to Firebase auth stream on app launch |
| `AuthUserChanged` | Fired when auth state changes (login/logout) |
| `AuthSignInWithEmail` | Email + password sign in |
| `AuthSignUpWithEmail` | Register new account |
| `AuthSignInWithGoogle` | Google OAuth sign in |
| `AuthSignOut` | Sign out and clear session |
| `AuthSendPasswordReset` | Send reset email |

| State | Description |
|-------|-------------|
| `AuthInitial` | App just launched |
| `AuthLoading` | Auth operation in progress |
| `AuthAuthenticated(user)` | User is signed in |
| `AuthUnauthenticated` | No active session |
| `AuthError(message)` | Auth operation failed |
| `AuthPasswordResetSent` | Reset email sent |

### TaskBloc
| Event | Description |
|-------|-------------|
| `TaskFetchAll(userId)` | Load all tasks from Firebase |
| `TaskAdd(task)` | POST new task to Firebase |
| `TaskUpdate(task)` | PUT updated task to Firebase |
| `TaskDelete(userId, taskId)` | DELETE task from Firebase |
| `TaskToggleCompletion(task)` | Toggle done/undone (optimistic) |
| `TaskFilterChanged(filter)` | Switch between All/Active/Completed |

| State | Description |
|-------|-------------|
| `TaskInitial` | No tasks loaded yet |
| `TaskLoading` | Fetching tasks |
| `TaskLoaded(allTasks, filteredTasks, filter)` | Tasks ready |
| `TaskOperationSuccess(message, ...)` | Add/Edit/Delete succeeded |
| `TaskError(message)` | Operation failed |

---

## 🔥 Firebase Setup

### Step 1 — Create a Firebase Project
1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project** → name it (e.g. `todo-bloc-app`) → continue

### Step 2 — Enable Authentication
1. In Firebase Console → **Authentication** → **Get started**
2. Enable **Email/Password** provider
3. *(Optional)* Enable **Google** provider and configure OAuth consent screen

### Step 3 — Enable Realtime Database
1. In Firebase Console → **Realtime Database** → **Create database**
2. Choose region → start in **test mode** (or configure rules below)
3. Copy your database URL (e.g. `https://your-project-id-default-rtdb.firebaseio.com`)
4. Update `lib/core/constants/app_constants.dart`:
```dart
static const String firebaseDbBaseUrl =
    'https://YOUR-PROJECT-ID-default-rtdb.firebaseio.com';
```

### Step 4 — Database Security Rules (Recommended)
In Realtime Database → Rules, paste:
```json
{
  "rules": {
    "tasks": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

### Step 5 — Add Flutter App via FlutterFire CLI
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure your app (run from project root)
flutterfire configure --project=YOUR-PROJECT-ID
```
This auto-generates `lib/firebase_options.dart` with your real config.

### Step 6 — Android SHA-1 (required for Google Sign-In)
```bash
cd android
./gradlew signingReport
```
Copy the **SHA-1** fingerprint → Firebase Console → Project Settings → Your Android App → Add fingerprint.

Also download the updated `google-services.json` and place it at `android/app/google-services.json`.

---

## 🚀 Running the App

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/todo_bloc_app.git
cd todo_bloc_app

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | User authentication |
| `google_sign_in` | Google OAuth |
| `flutter_bloc` | BLoC state management |
| `bloc` | BLoC core library |
| `equatable` | Value equality for states/events |
| `http` | Firebase Realtime Database REST API |
| `flutter_slidable` | Swipe-to-action on task cards |
| `animate_do` | FadeIn/slide animations |
| `fluttertoast` | Toast notifications |
| `uuid` | Generate unique task IDs |
| `intl` | Date formatting |
| `shimmer` | Loading skeleton effect |
| `shared_preferences` | Local preference storage |

---

## 📸 Screens

| Login | Sign Up | Tasks | Add Task |
|-------|---------|-------|----------|
| Email/password form | Registration with validation | Task list with filters | Bottom sheet form |
| Google Sign-In button | Confirm password | Swipe to edit/delete | Priority + due date |
| Forgot password flow | Auto-navigate on success | Stats header | Animated submit |

---

## 🔒 Security Notes

- **Never commit** your real `firebase_options.dart` or `google-services.json` to a public repository
- Add them to `.gitignore` if they contain real credentials
- Firebase Database rules restrict each user to only their own tasks

---

## 🗒️ .gitignore Additions

```
# Firebase
google-services.json
GoogleService-Info.plist
lib/firebase_options.dart   # Only if it contains real keys

# Flutter
.dart_tool/
build/
*.iml
.flutter-plugins
.flutter-plugins-dependencies
```

---

## 👤 Author

Built as a Flutter BLoC architecture showcase with Firebase integration.

**Deadline:** 10/03/2026 before 7 PM ✅
>>>>>>> todo
