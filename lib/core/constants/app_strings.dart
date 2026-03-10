// lib/core/constants/app_strings.dart

class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'TodoBloc';

  // Auth
  static const String login = 'Login';
  static const String signUp = 'Sign Up';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String orContinueWith = 'Or continue with';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String welcomeBack = 'Welcome Back!';
  static const String createAccount = 'Create Account';
  static const String signInSubtitle = 'Sign in to manage your tasks';
  static const String signUpSubtitle = 'Start organizing your life today';

  // Tasks
  static const String myTasks = 'My Tasks';
  static const String addTask = 'Add Task';
  static const String editTask = 'Edit Task';
  static const String deleteTask = 'Delete Task';
  static const String taskTitle = 'Task Title';
  static const String taskDescription = 'Description (optional)';
  static const String taskDueDate = 'Due Date';
  static const String taskPriority = 'Priority';
  static const String noTasks = 'No tasks yet!';
  static const String noTasksSubtitle = 'Tap + to add your first task';
  static const String allTasks = 'All';
  static const String activeTasks = 'Active';
  static const String completedTasks = 'Completed';
  static const String deleteConfirm = 'Are you sure you want to delete this task?';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String update = 'Update';

  // Validation
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Enter a valid email address';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordMismatch = 'Passwords do not match';

  // Errors
  static const String somethingWentWrong = 'Something went wrong. Try again.';
  static const String networkError = 'Network error. Check your connection.';
  static const String userNotFound = 'No user found with this email.';
  static const String wrongPassword = 'Incorrect password.';
  static const String emailAlreadyInUse = 'Email is already registered.';

  // Success
  static const String taskAdded = 'Task added successfully!';
  static const String taskUpdated = 'Task updated successfully!';
  static const String taskDeleted = 'Task deleted successfully!';
  static const String passwordResetSent = 'Password reset email sent!';
}
