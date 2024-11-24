import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abastecimentoflutter/views/screens/home.dart';
import 'package:abastecimentoflutter/views/screens/meusveiculos.dart';
import 'package:abastecimentoflutter/views/screens/addveiculo.dart';
import 'package:abastecimentoflutter/views/screens/historico.dart';
import 'package:abastecimentoflutter/views/screens/perfil.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text([
          "Home",
          "Meus Veículos",
          "Adicionar Veículo",
          "Histórico de Abastecimentos",
          "Perfil"
        ][_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      FirebaseAuth.instance.currentUser!.displayName ?? "User"),
                  Text(FirebaseAuth.instance.currentUser!.email!),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Meus Veículos'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text('Adicionar Veículo'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Histórico de Abastecimentos'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () => _onItemTapped(4),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: [
        const HomeView(),
        MyVehiclesView(),
        AddVehicleView(),
        const RefuelHistoryView(),
        const ProfileView(),
      ][_selectedIndex],
    );
  }
}
