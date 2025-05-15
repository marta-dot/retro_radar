import 'package:google_sign_in/google_sign_in.dart';
import 'package:retro_radar/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User?> get currentUser => authService.currentUser;

  loginGoogle() async {
    try {
      // await googleSignIn.signOut(); // pozwala użytkownikowi wybrać inne konto

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      //Firebase sign in
      await authService.signInWithCredencial(credential);
      // final result = await authService.signInWithCredencial(credential);
      // print('${result.user?.displayName ?? "No display name"}');
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await googleSignIn.signOut(); // wyloguj z Google
    await authService.logout(); // wyloguj z Firebase
  }
}
