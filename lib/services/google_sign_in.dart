import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService{
  static final _googleSignIn = GoogleSignIn(
      clientId: '203347747842-2uq462l0kh21istb4db60mm87os3tark.apps.googleusercontent.com'
  );

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future logout() => _googleSignIn.signOut();
}