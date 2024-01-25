// google_sign_in_state.dart

part of 'google_sign_in_bloc.dart';

enum GoogleSignInStatus { authenticated, unauthenticated, unknown, processing, failure }

class GoogleSignInState extends Equatable {
  const GoogleSignInState._({
    this.status = GoogleSignInStatus.unknown,
    this.user,
  });

  const GoogleSignInState.unknown() : this._();

  const GoogleSignInState.authenticated(User user)
      : this._(status: GoogleSignInStatus.authenticated, user: user);

  const GoogleSignInState.unauthenticated()
      : this._(status: GoogleSignInStatus.unauthenticated);

  const GoogleSignInState.processing()
      : this._(status: GoogleSignInStatus.processing);

  const GoogleSignInState.failure()
      : this._(status: GoogleSignInStatus.failure);

  final GoogleSignInStatus status;
  final User? user;

  @override
  List<Object?> get props => [status, user];
}
