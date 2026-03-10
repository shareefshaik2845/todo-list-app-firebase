// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // Firebase Realtime Database base URL - replace with your project URL
  static const String firebaseDbBaseUrl =
      'https://todo-list-b3dfc-default-rtdb.firebaseio.com/';

  // Collection / node names
  static const String tasksNode = 'tasks';
  static const String usersNode = 'users';

  // Shared Preferences keys
  static const String prefUserToken = 'user_token';
  static const String prefUserId = 'user_id';

  // Task priority levels
  static const String priorityHigh = 'high';
  static const String priorityMedium = 'medium';
  static const String priorityLow = 'low';
}
