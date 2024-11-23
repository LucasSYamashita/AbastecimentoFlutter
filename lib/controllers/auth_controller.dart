import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registro de usuário
  Future<void> registerUser(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // Login do usuário
  Future<void> loginUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Recuperação de senha
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Estado do usuário autenticado
  Stream<User?> get userChanges => _auth.authStateChanges();
}
