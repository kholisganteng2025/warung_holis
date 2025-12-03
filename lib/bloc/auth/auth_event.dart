part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}
// State ==> kondisi saat ini
// 1. AuthEventLogin -> Melakukan tindakan login
// 2. AuthEventLogout -> Melakukan tindakan logout

class AuthEventLogin extends AuthEvent {
  AuthEventLogin(this.email, this.password);

  final String email;
  final String password;
}

class AuthEventLogout extends AuthEvent {}
