import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:abastecimentoflutter/views/login.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onItemTapped; // Função para alterar o índice da tela

  CustomDrawer({super.key, required this.onItemTapped});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.orange),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Usuário',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'email@exemplo.com',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              onItemTapped(0); // Muda para a tela Home
              Navigator.pop(context); // Fecha o drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Meus Veículos'),
            onTap: () {
              onItemTapped(1); // Muda para a tela Meus Veículos
              Navigator.pop(context); // Fecha o drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('Adicionar Veículo'),
            onTap: () {
              onItemTapped(2); // Muda para a tela Adicionar Veículo
              Navigator.pop(context); // Fecha o drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de Abastecimentos'),
            onTap: () {
              onItemTapped(3); // Muda para a tela Histórico
              Navigator.pop(context); // Fecha o drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              onItemTapped(4); // Muda para a tela Perfil
              Navigator.pop(context); // Fecha o drawer
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
