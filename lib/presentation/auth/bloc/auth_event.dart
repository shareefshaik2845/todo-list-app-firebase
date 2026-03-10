// lib/presentation/auth/bloc/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthSignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpWithEmail extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const AuthSignUpWithEmail({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class AuthSignInWithGoogle extends AuthEvent {
  const AuthSignInWithGoogle();
}

class AuthSignOut extends AuthEvent {
  const AuthSignOut();
}

class AuthSendPasswordReset extends AuthEvent {
  final String email;
  const AuthSendPasswordReset({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthUserChanged extends AuthEvent {
  final dynamic user;
  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}
