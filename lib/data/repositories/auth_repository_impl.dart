// lib/data/repositories/auth_repository_impl.dart
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;

  @override
  UserEntity? get currentUser => _dataSource.currentUser;

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    return await _dataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmail(
      String email, String password, String displayName) async {
    return await _dataSource.signUpWithEmail(email, password, displayName);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    return await _dataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return await _dataSource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    return await _dataSource.sendPasswordResetEmail(email);
  }
}
