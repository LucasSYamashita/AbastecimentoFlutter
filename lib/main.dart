import 'package:abastecimentoflutter/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:abastecimentoflutter/views/login.dart'; // Importando Login
import 'package:abastecimentoflutter/views/main_app.dart'; // Importando MainApp

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Future<void> _autoLogin() async {
  try {
    if (FirebaseAuth.instance.currentUser == null) {
      // Usuário não logado, fazer login com credenciais padrão
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "admin@gmail.com",
        password: "admin1", // Garanta que este usuário existe no Firebase
      );
    }
  } catch (e) {
    // Em caso de erro, exiba no console
    print("Erro no login automático: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Abastecimento',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance
            .authStateChanges(), // Verifica se o usuário está logado
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const MainApp(); // Se estiver logado, vai para o MainApp
            } else {
              return LoginView(); // Remover o 'const' aqui
            }
          } else {
            return const Center(
                child: CircularProgressIndicator()); // Exibe um carregamento
          }
        },
      ),
    );
  }
}
