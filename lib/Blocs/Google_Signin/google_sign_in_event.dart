// google_sign_in_event.dart

part of 'google_sign_in_bloc.dart';

abstract class GoogleSignInEvent extends Equatable {
  const GoogleSignInEvent();

  @override
  List<Object?> get props => [];
}

class GoogleSignInRequested extends GoogleSignInEvent {}

class GoogleSignOutRequested extends GoogleSignInEvent {}

class GoogleSignInUserChanged extends GoogleSignInEvent {
  final User? user;

  const GoogleSignInUserChanged(this.user);
}
