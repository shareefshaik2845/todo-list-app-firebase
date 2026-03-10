# Todo BLoC App - Project Documentation

## 📋 Project Overview

**Todo BLoC App** is a production-ready, feature-rich To-Do List application built with **Flutter**, **Firebase**, and **BLoC** state management following **Clean Architecture** principles. The application provides secure authentication, real-time task management, and a beautiful, responsive user interface with full dark mode support.

**Application Type:** Cross-Platform Mobile Application (iOS, Android, Web)  
**Framework:** Flutter 3.0.0+  
**State Management:** BLoC (Business Logic Component)  
**Backend:** Firebase (Authentication & Realtime Database)  
**Architecture Pattern:** Clean Architecture + BLoC  

---

## 🎯 Key Features

### 1. **Authentication System**
- **Email/Password Authentication:**
  - User signup with email and password
  - Secure login with credential validation
  - Password reset functionality
  - Account verification

- **Google Sign-In:**
  - One-tap Google authentication
  - Seamless account linking
  - Android & iOS support
  - Web-specific OAuth configuration

- **Session Management:**
  - Persistent user sessions
  - Automatic token refresh
  - Logout functionality
  - Secure credential storage via Firebase

### 2. **Task Management (Full CRUD)**
- **Create Tasks:**
  - Add new tasks with title and optional description
  - Set priority levels (High / Medium / Low)
  - Set due dates with date picker
  - Auto-generated unique task IDs (UUID v4)

- **Read Tasks:**
  - View all tasks in a scrollable list
  - Task details with all metadata
  - Visual task status display
  - Overdue task indicators

- **Update Tasks:**
  - Edit existing task details
  - Modify priority and due dates
  - Update completion status
  - All changes persisted to Firebase

- **Delete Tasks:**
  - Swipe-to-delete action
  - Confirmation dialogs
  - Soft delete or permanent deletion
  - Undo functionality

### 3. **Task Filtering & Organization**
- **Filter Views:**
  - **All Tasks:** Complete task list
  - **Active Tasks:** Incomplete tasks only
  - **Completed Tasks:** Finished tasks only

- **Visual Organization:**
  - Grouped by status (completed/active)
  - Priority-based color coding
    - 🔴 High (Red)
    - 🟡 Medium (Amber/Orange)
    - 🟢 Low (Green)
  - Due date indicators

- **Statistics Display:**
  - Total task count
  - Active task count
  - Completion percentage
  - Real-time statistics updates

### 4. **Task Priority System**
- **Priority Levels:**
  - **High:** Urgent, time-sensitive tasks
  - **Medium:** Standard tasks
  - **Low:** Non-urgent tasks

- **Visual Indicators:**
  - Color-coded priority badges
  - Priority chips in task list
  - Quick priority selection in task form

### 5. **Due Date Management**
- **Date Features:**
  - Calendar date picker
  - Nullable due dates (optional)
  - Overdue task detection
  - Visual overdue indicators
  - Chronological sorting capability

- **Date Display:**
  - Formatted date strings (e.g., "Mar 15, 2026")
  - "Overdue" label for past dates
  - "Today" label for current date
  - "Tomorrow" label for next day

### 6. **User Interface & UX**
- **Responsive Design:**
  - Adaptive layouts for all screen sizes
  - Portrait and landscape orientation support
  - Tablet-optimized spacing

- **Animations:**
  - FadeIn transitions for task appearance
  - Slide animations for list items
  - Smooth state transitions
  - Delete confirmation animations

- **Interactive Elements:**
  - Swipe-to-delete with `flutter_slidable`
  - Floating Action Button (FAB) for new tasks
  - Bottom sheet for task creation/editing
  - Interactive task completion toggle

- **Visual Feedback:**
  - Loading animations (shimmer effect)
  - Toast notifications for operations
  - Error dialogs with helpful messages
  - Success confirmations

### 7. **Theme Support**
- **Light & Dark Modes:**
  - System-aware theme detection
  - Manual theme switching option
  - Material 3 design system
  - Consistent colors across both themes

- **Color Scheme:**
  - Primary brand color
  - Surface colors for backgrounds
  - Error colors for validation
  - Semantic colors (success, warning)

### 8. **Real-Time Synchronization**
- **Firebase Realtime Database:**
  - REST API integration using HTTP
  - Real-time data synchronization
  - Offline-capable structure
  - User-specific data isolation
  - Automatic timestamp management

- **Data Persistence:**
  - All tasks stored in Firebase
  - User authentication state persistence
  - Device-independent data access
  - Cross-device synchronization

---

## 🏗️ Architecture & Structure

### Clean Architecture Layers

The application follows **Clean Architecture** with clear separation of concerns:

```
lib/
│
├── domain/                           # Enterprise Business Rules (Framework-independent)
│   ├── entities/
│   │   ├── task.dart                # Task business entity
│   │   └── user_entity.dart         # User business entity
│   └── repositories/
│       ├── auth_repository.dart     # Auth interface (abstract)
│       └── task_repository.dart     # Task interface (abstract)
│
├── data/                             # Application Business Rules (Framework-dependent)
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart   # Firebase Auth wrapper
│   │   └── task_remote_datasource.dart   # Firebase RTDB REST API wrapper
│   │
│   ├── models/
│   │   ├── task_model.dart              # Task serialization/deserialization
│   │   └── user_model.dart              # User serialization/deserialization
│   │
│   └── repositories/
│       ├── auth_repository_impl.dart    # Auth repository implementation
│       └── task_repository_impl.dart    # Task repository implementation
│
├── presentation/                     # Interface Adapters (UI Layer)
│   ├── auth/
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart       # Authentication state management
│   │   │   ├── auth_event.dart      # Auth events (Login, Signup, Logout)
│   │   │   └── auth_state.dart      # Auth states (Loading, Success, Error)
│   │   │
│   │   ├── pages/
│   │   │   ├── login_page.dart      # Login UI screen
│   │   │   └── signup_page.dart     # Signup UI screen
│   │   │
│   │   └── widgets/
│   │       ├── auth_text_field.dart # Custom input field
│   │       └── google_sign_in_button.dart
│   │
│   ├── tasks/
│   │   ├── bloc/
│   │   │   ├── task_bloc.dart       # Task state management
│   │   │   ├── task_event.dart      # Task events (Add, Update, Delete, Fetch)
│   │   │   └── task_state.dart      # Task states (Loading, Loaded, Error)
│   │   │
│   │   ├── pages/
│   │   │   └── tasks_page.dart      # Main tasks UI screen
│   │   │
│   │   └── widgets/
│   │       ├── task_list_item.dart           # Individual task display
│   │       ├── task_filter_chip.dart        # Filter selection chips
│   │       ├── tasks_header.dart            # Statistics header
│   │       └── add_edit_task_sheet.dart     # Task creation/editing form
│   │
│   └── splash/
│       └── splash_page.dart         # Loading/splash screen
│
├── core/                             # Cross-cutting Concerns
│   ├── constants/
│   │   ├── app_constants.dart       # Firebase URLs, priority values
│   │   └── app_strings.dart         # All UI string constants
│   │
│   ├── errors/
│   │   └── failures.dart            # Failure type definitions
│   │
│   ├── theme/
│   │   └── app_theme.dart           # Material theme definitions
│   │
│   └── utils/
│       ├── date_formatter.dart      # Date formatting & logic
│       └── validators.dart          # Form validation helpers
│
├── firebase_options.dart            # Firebase configuration
└── main.dart                        # Application entry point
```

### Architecture Flow Diagram

```
User Interaction (UI)
   ↓
Presentation Layer (Pages/Widgets)
   ↓
BLoC (EventStream → add events)
   ↓
Use Cases / Repository Pattern
   ↓
Data Layer (Remote DataSource)
   ↓
Firebase API / HTTP Client
   ↓
Response Processing
   ↓
Model → Entity Conversion
   ↓
BLoC (emit new State)
   ↓
UI Rebuild (BlocBuilder/BlocListener)
```

---

## 🔌 BLoC Pattern Implementation

### Event-Driven Architecture

The application uses the **BLoC pattern** for predictable state management:

#### **AuthBloc** - Authentication State Management

**Events:**
- `SignUpRequested` - User signup request
- `LoginRequested` - User login request
- `GoogleSignInRequested` - Google sign-in request
- `LogoutRequested` - User logout request
- `PasswordResetRequested` - Password reset request
- `AuthStatusChecked` - Check current auth status

**States:**
- `AuthInitial` - Initial state
- `AuthLoading` - Processing authentication
- `AuthAuthenticated` - User logged in
- `AuthUnauthenticated` - User logged out
- `AuthError` - Authentication failed
- `AuthOperationSuccess` - Operation completed

#### **TaskBloc** - Task Management State Management

**Events:**
- `TaskFetchAll` - Retrieve all tasks
- `TaskAdd` - Create new task
- `TaskUpdate` - Modify existing task
- `TaskDelete` - Remove task
- `TaskToggleCompletion` - Mark task as done/undone
- `TaskFilterChanged` - Change task filter view
- `TaskRefresh` - Refresh task list

**States:**
- `TaskInitial` - Initial state
- `TaskLoading` - Fetching/processing tasks
- `TaskLoaded` - Tasks successfully loaded with metadata
- `TaskError` - Operation failed
- `TaskOperationSuccess` - Operation completed successfully

### BLoC to Repository Pattern

```
BLoC receives event
   ↓
Calls repository method
   ↓
Repository calls remote data source
   ↓
Data source makes HTTP/Firebase request
   ↓
Response received
   ↓
Map model to entity
   ↓
BLoC emits new state
   ↓
UI listens and rebuilds
```

---

## 📊 Data Models

### Task Entity & Model

**TaskEntity (Domain Layer):**
- Immutable representation of task
- Contains all task properties
- Extends `Equatable` for equality checking
- `copyWith()` method for immutable updates

**TaskModel (Data Layer):**
- JSON serialization/deserialization
- `fromJson()` factory constructor
- `toJson()` method for API requests
- Extends TaskEntity for polymorphism

**Task Properties:**
```dart
- id: String              # UUID v4 unique identifier
- userId: String          # Owner of the task
- title: String          # Task title (required)
- description: String    # Task details (optional)
- isCompleted: bool      # Completion status (default: false)
- priority: String       # "high" | "medium" | "low" (default: "medium")
- dueDate: DateTime?     # Optional deadline
- createdAt: DateTime    # Timestamp of creation
- updatedAt: DateTime    # Last modification timestamp
```

### User Entity & Model

**UserEntity (Domain Layer):**
- User account information
- Authentication credentials reference
- Profile metadata

**UserModel (Data Layer):**
- Firebase user mapping
- JSON serialization for storage

**User Properties:**
```dart
- uid: String            # Firebase UID (immutable)
- email: String          # Email address
- displayName: String?   # User's display name
- photoUrl: String?      # Profile picture URL
- createdAt: DateTime    # Account creation date
- lastLogin: DateTime?   # Last login timestamp
```

---

## 🔐 Firebase Integration

### Firebase Services Used

1. **Firebase Authentication**
   - Email/Password provider
   - Google OAuth provider
   - Session token management
   - User credential storage

2. **Firebase Realtime Database**
   - REST API access via HTTP
   - Task data storage structure:
     ```
     /users/{userId}/tasks/{taskId}
     ```
   - Real-time synchronization
   - User-scoped data isolation

3. **Firebase Configuration**
   - Multi-platform support (Android, iOS, Web)
   - Auto-generated `firebase_options.dart`
   - Project ID: `todo-list-b3dfc`

### REST API Integration

**HTTP Client Usage:**
- Direct Firebase REST API calls
- Custom headers for authentication
- JSON request/response handling
- Error handling with status codes

**API Endpoints:**
```
GET /users/{userId}/tasks.json?auth={token}
POST /users/{userId}/tasks.json?auth={token}
PUT /users/{userId}/tasks/{taskId}.json?auth={token}
DELETE /users/{userId}/tasks/{taskId}.json?auth={token}
```

---

## 🎨 UI Components & Widgets

### Custom Widgets

1. **TaskListItem** - Individual task display
   - Shows title, priority, due date
   - Completion checkbox
   - Swipe actions (edit/delete)
   - Overdue indicator

2. **AddEditTaskSheet** - Task form
   - Bottom sheet UI
   - Title & description input
   - Priority selector
   - Date picker
   - Submit/Cancel buttons

3. **TaskFilterChips** - Filter selection
   - "All Tasks" chip
   - "Active" chip
   - "Completed" chip
   - Visual selection indication

4. **TasksHeader** - Statistics display
   - Total task count
   - Active task count
   - Completion percentage
   - Visual progress indicator

5. **AuthTextField** - Secure input field
   - Password masking option
   - Input validation feedback
   - Hint text support

6. **GoogleSignInButton** - Social authentication
   - Google branding
   - Loading state handling
   - Error feedback

### Material Design Components

- **AppBar** - Header navigation
- **FloatingActionButton** - Quick task creation
- **BottomSheet** - Task form modal
- **Chip** - Filter and priority indicators
- **Slidable** - Swipe-to-delete interaction
- **SnackBar** - Toast notifications
- **AlertDialog** - Confirmation dialogs
- **CircularProgressIndicator** - Loading states

---

## 🎬 Animations & Transitions

### Animation Libraries

1. **animate_do** - Pre-built animation widgets
   - `FadeIn` - Fade entrance effect
   - `SlideInUp` - Slide-up animation
   - `Bounce` - Bounce effect

2. **shimmer** - Loading state animation
   - Shimmering skeleton screens
   - Loading state feedback

3. **flutter_slidable** - Swipe gestures
   - Swipe-to-delete interaction
   - Swipe-to-edit action
   - Customizable swipe behavior

### Animation Effects

- Task loading: Shimmer effect
- Task appearance: FadeIn + SlideInUp
- Filter switch: Smooth transition
- Delete action: Confirmation animation fade out
- State change: Opacity transitions

---

## 💾 Data Persistence & Sync

### Real-Time Synchronization

1. **Optimistic UI Updates:**
   - Update UI immediately on user action
   - Sync to Firebase in background
   - Rollback on error

2. **Data Synchronization:**
   - All tasks synced to Firebase Realtime DB
   - User-specific data isolation via UID
   - Timestamps for conflict resolution
   - Automatic retry on connection loss

3. **Offline Capability:**
   - Task list cached locally
   - Operations queued offline
   - Sync when connection restored

### Database Structure

```
Firebase Realtime Database:
├── users
│   └── {userId}
│       └── tasks
│           └── {taskId}
│               ├── title: String
│               ├── description: String
│               ├── isCompleted: boolean
│               ├── priority: String
│               ├── dueDate: timestamp
│               ├── createdAt: timestamp
│               └── updatedAt: timestamp
```

---

## 🎨 Theme System

### Material Design 3 Theme

**Light Theme:**
- Primary Color: Brand color
- Surface Color: White/Off-white
- Text Color: Dark gray/black
- Secondary Colors: Accent colors

**Dark Theme:**
- Primary Color: Lighter variant
- Surface Color: Dark gray/black
- Text Color: White/light gray
- Secondary Colors: Adjusted for dark backgrounds

### Theme Implementation

- `AppTheme` class with predefined themes
- Dynamic theme switching capability
- System preference detection
- Consistent colors across all screens

---

## 🔄 User Workflows

### Authentication Flow

```
1. Launch App
   ↓
2. Check if user authenticated
   ↓
3a. If authenticated → Navigate to Tasks Page
3b. If not → Navigate to Login/Signup
   ↓
4. User enters credentials or uses Google Sign-In
   ↓
5. Firebase validates and returns auth token
   ↓
6. Save token locally
   ↓
7. Navigate to Tasks Page
```

### Task Management Flow

```
1. User views Tasks Page
   ↓
2. Fetch all tasks from Firebase
   ↓
3. Display tasks in list (filtered by view)
   ↓
4. User actions:
   a) Create: FAB → Form → Submit → Firebase
   b) Read: Tap task → View details
   c) Update: Swipe left → Edit → Form → Submit
   d) Delete: Swipe left → Delete → Confirm
   e) Complete: Tap checkbox → Toggle status
   ↓
5. Update reflected in UI
   ↓
6. Data synced to Firebase
```

### Task Filtering Flow

```
1. User taps filter chip
   ↓
2. Selected filter sent to TaskBloc
   ↓
3. TaskBloc emits new filtered state
   ↓
4. UI rebuilds with filtered task list
   ↓
5. Statistics updated
```

---

## 📦 Dependencies & Technologies

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter | SDK | Core framework |
| dart | >=3.0.0 <4.0.0 | Programming language |
| firebase_core | ^3.6.0 | Firebase initialization |
| firebase_auth | ^5.3.1 | Firebase authentication |
| google_sign_in | ^6.2.1 | Google OAuth integration |
| flutter_bloc | ^8.1.6 | BLoC state management |
| bloc | ^8.1.4 | BLoC core library |
| equatable | ^2.0.5 | Value equality |
| http | ^1.2.2 | HTTP networking for REST API |
| uuid | ^4.4.2 | Generate unique IDs |
| intl | ^0.19.0 | Internationalization & date formatting |
| shared_preferences | ^2.3.2 | Local key-value storage |

### UI Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_svg | ^2.0.10+1 | SVG asset rendering |
| lottie | ^3.1.2 | JSON animations |
| shimmer | ^3.0.0 | Loading skeleton animation |
| fluttertoast | ^8.2.8 | Toast notifications |
| flutter_slidable | ^3.1.1 | Swipe-to-delete gesture |
| animate_do | ^3.3.4 | Pre-built animations |
| cupertino_icons | ^1.0.8 | iOS-style icons |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_test | SDK | Testing framework |
| flutter_lints | ^4.0.0 | Linting rules |

---

## 🔒 Security Features

### Authentication Security

1. **Firebase Authentication:**
   - Secure password hashing
   - Token-based authentication
   - OAuth 2.0 for Google Sign-In
   - Automatic token expiration

2. **Session Management:**
   - Secure token storage
   - Automatic re-authentication
   - Logout clears sensitive data

3. **Data Security:**
   - Firebase Realtime DB security rules
   - User-scoped data isolation
   - HTTPS encryption for API calls

### Input Validation

1. **Form Validation:**
   - Email format checking
   - Password strength requirements
   - Required field validation
   - Real-time validation feedback

2. **Data Sanitization:**
   - Trim whitespace
   - XSS prevention
   - SQL injection protection (via structured data)

---

## 🚀 Setup & Installation

### Prerequisites

- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Firebase project account
- Android SDK (for Android development)
- Xcode (for iOS development)
- Google account (for Sign-In OAuth setup)

### Installation Steps

1. **Clone Repository:**
   ```bash
   cd todo_bloc_app/todo_app
   ```

2. **Get Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup:**
   - Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable Email/Password authentication
   - Enable Google Sign-In provider
   - Create Realtime Database
   - Set database security rules for user-specific access

4. **Configure Flutter:**
   ```bash
   flutterfire configure
   ```
   - This generates `firebase_options.dart` automatically

5. **Run Application:**
   ```bash
   flutter run
   ```

6. **Build for Production:**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   
   # Web
   flutter build web --release
   ```

---

## 🛠️ Development Guidelines

### Folder Organization

- Use `lib/domain/` for business entities and interfaces
- Use `lib/data/` for repositories and data sources
- Use `lib/presentation/` for UI screens and widgets
- Use `lib/core/` for constants, themes, utilities

### State Management Best Practices

1. **Single Responsibility:**
   - One BLoC per major feature
   - Separate events for each action
   - Clean state definitions

2. **Event Handling:**
   - Clear event naming
   - Immutable event properties
   - Proper event sequencing

3. **Error Handling:**
   - Always emit error states
   - Provide user-friendly error messages
   - Log errors for debugging

### Code Standards

- Follow Dart style guide
- Use meaningful variable names
- Document complex logic
- Add type annotations
- Keep methods focused and small

---

## 🧪 Testing

### Test Files Location

- Unit tests: `test/domain/` `test/data/`
- Widget tests: `test/presentation/`
- Integration tests: `test/integration/`

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/presentation/tasks/bloc/task_bloc_test.dart

# Generate coverage report
flutter test --coverage

# View coverage
genhtml coverage/lcov.info -o coverage/html
```

### Test Coverage

- BLoC logic and state transitions
- Repository implementations
- Widget rendering and interactions
- Error handling scenarios
- Input validation logic

---

## 📈 Future Enhancements

- [ ] Task categories/tags
- [ ] Task reminders and notifications
- [ ] Recurring tasks
- [ ] Task attachments/images
- [ ] Collaborative task sharing
- [ ] Task search functionality
- [ ] Sync across multiple devices
- [ ] Offline mode with better UX
- [ ] Task templates
- [ ] Analytics dashboard
- [ ] Export tasks (PDF, CSV)
- [ ] Calendar view
- [ ] Voice task creation
- [ ] AI task suggestions
- [ ] Time tracking per task

---

## 🔧 Troubleshooting

### Common Issues

1. **Firebase Connection Error:**
   - Verify Firebase project ID in `firebase.json`
   - Check internet connection
   - Ensure Firebase credentials are valid

2. **Google Sign-In Not Working:**
   - Verify Web Client ID for web platform
   - Check OAuth scopes configuration
   - Ensure GoogleService-Info.plist (iOS) is added

3. **Tasks Not Syncing:**
   - Check Firebase Realtime Database rules
   - Verify user authentication status
   - Check network connectivity

4. **UI Not Updating:**
   - Verify BLoC listeners are proper
   - Check state equality with Equatable
   - Ensure proper event emission

---

## 📚 Resources & References

### Official Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Library Documentation](https://bloclibrary.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Material Design 3](https://material.io/components)

### Useful Libraries

- [Provider](https://pub.dev/packages/provider)
- [GetIt](https://pub.dev/packages/get_it) - Service locator
- [Freezed](https://pub.dev/packages/freezed) - Code generation
- [AutoRoute](https://pub.dev/packages/auto_route) - Navigation

---

## 📞 Support & Maintenance

### Development Team

For questions or issues regarding the Todo BLoC App development, contact the development team or open an issue in the repository.

### Performance Optimization

- Monitor BLoC rebuild frequency
- Cache frequently used data
- Optimize list rendering with `ListView.builder`
- Profile app with DevTools

### Maintenance

- Keep Firebase SDK updated
- Monitor security advisories
- Regular dependency updates
- Monitor app analytics

---

**Last Updated:** March 2026  
**Project Version:** 1.0.0+1  
**Flutter Version:** 3.0.0+  
**Architecture:** Clean Architecture + BLoC
