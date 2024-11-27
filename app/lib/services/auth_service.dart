import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Registro con email, contraseña y nombre
  Future<User?> registerWithEmail(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  // Inicio de sesión con email y contraseña
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  // Inicio de sesión con Google
  Future<User?> loginWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // El usuario canceló el inicio de sesión
      }

      // Obtener las credenciales de autenticación de Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase con las credenciales de Google
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  // Cerrar sesión
  Future<String?> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      return null;
    } catch (e) {
      return 'Algo salió mal';
    }
  }

  // Función para eliminar al usuario actual
  Future<bool> deleteUser() async {
    try {
      User? user = _auth.currentUser;

      await user!.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
