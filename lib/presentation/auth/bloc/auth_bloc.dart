// lib/presentation/auth/bloc/auth_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthSignInWithEmail>(_onSignInWithEmail);
    on<AuthSignUpWithEmail>(_onSignUpWithEmail);
    on<AuthSignInWithGoogle>(_onSignInWithGoogle);
    on<AuthSignOut>(_onSignOut);
    on<AuthSendPasswordReset>(_onSendPasswordReset);

    add(const AuthStarted());
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    _authSubscription?.cancel();
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthUserChanged(user));
    });
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithEmail(
      AuthSignInWithEmail event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(
          event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignUpWithEmail(
      AuthSignUpWithEmail event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signUpWithEmail(
          event.email, event.password, event.displayName);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignInWithGoogle(
      AuthSignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSendPasswordReset(
      AuthSendPasswordReset event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authRepository.sendPasswordResetEmail(event.email);
      emit(const AuthPasswordResetSent());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
