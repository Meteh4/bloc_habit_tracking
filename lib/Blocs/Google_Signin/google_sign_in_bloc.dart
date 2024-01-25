import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_repository/user_repository.dart';

part 'google_sign_in_event.dart';
part 'google_sign_in_state.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final UserRepository userRepository;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final StreamSubscription<User?> _userSubscription;

  GoogleSignInBloc({
    required this.userRepository,
  }) : super(const GoogleSignInState.unknown()) {
    _userSubscription = userRepository.user.listen((user) {
      add(GoogleSignInUserChanged(user));
    });

    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<GoogleSignOutRequested>(_onGoogleSignOutRequested);
  }

  void _onGoogleSignInRequested(
      GoogleSignInRequested event,
      Emitter<GoogleSignInState> emit,
      ) async {
    try {
      emit(GoogleSignInState.processing());
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(const GoogleSignInState.unauthenticated());
      } else {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      emit(const GoogleSignInState.failure());
    }
  }

  void _onGoogleSignOutRequested(
      GoogleSignOutRequested event,
      Emitter<GoogleSignInState> emit,
      ) async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Handle sign-out failure
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
