part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

// State ==> kondisi saat ini
// 1. AuthStateLogin -> tidak terauthentikasi
// 2. AuthStateLogout -> terAuthentikasi
// 3. AuthStateLoading -> loading
// 3. AuthStateError -> gagal Login -> dapat error

class AuthInitial extends AuthState {}

class AuthStateLogin extends AuthState {}

class AuthStateLogout extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateError extends AuthState {
  AuthStateError(this.message);
  final String message;
}
