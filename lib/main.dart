import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import 'core/theme/app_theme.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/task_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/task_repository_impl.dart';

import 'firebase_options.dart';

import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/bloc/auth_state.dart';
import 'presentation/auth/pages/login_page.dart';

import 'presentation/splash/splash_page.dart';

import 'presentation/tasks/bloc/task_bloc.dart';
import 'presentation/tasks/pages/tasks_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {

    final firebaseAuth = FirebaseAuth.instance;

    final googleSignIn = kIsWeb
    ? GoogleSignIn(
        clientId: '63833441556-16e0liae6ovt4lcf9s1r7gsickroig0k.apps.googleusercontent.com',
      )
    : GoogleSignIn();

    final httpClient = http.Client();

    final authDataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    );

    final authRepository =
    AuthRepositoryImpl(dataSource: authDataSource);

    final taskDataSource = TaskRemoteDataSourceImpl(
      client: httpClient,
      firebaseAuth: firebaseAuth,
    );

    final taskRepository =
    TaskRepositoryImpl(dataSource: taskDataSource);

    return MultiBlocProvider(
      providers: [

        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authRepository: authRepository,
          ),
        ),

        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(
            taskRepository: taskRepository,
          ),
        ),

      ],
      child: MaterialApp(
        title: 'Todo Bloc',
        debugShowCheckedModeBanner: false,

        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        home: const AppNavigator(),
      ),
    );
  }
}

/// Navigator based on auth state
class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {

        if (state is AuthInitial || state is AuthLoading) {
          return const SplashPage();
        }

        if (state is AuthAuthenticated) {
          return TasksPage(user: state.user);
        }

        return const LoginPage();
      },
    );
  }
}