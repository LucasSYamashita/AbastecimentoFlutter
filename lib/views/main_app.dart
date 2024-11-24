import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:abastecimentoflutter/views/screens/home.dart';
import 'package:abastecimentoflutter/views/screens/meusveiculos.dart';
import 'package:abastecimentoflutter/views/screens/addveiculo.dart';
import 'package:abastecimentoflutter/views/screens/historico.dart';
import 'package:abastecimentoflutter/views/screens/perfil.dart';
import 'package:abastecimentoflutter/widgets/custom_drawer.dart'; // Importando o CustomDrawer

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0; // Índice da página selecionada
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  // Método para alterar o índice da página
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Função para logout
  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(
        context, '/login'); // Redireciona para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Abastecimento'),
      ),
      drawer: CustomDrawer(
          onItemTapped: _onItemTapped), // Passando a função de navegação
      body: _getBody(), // Corpos das páginas baseados no índice selecionado
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Indica qual aba está selecionada
        onTap: _onItemTapped, // Altera a tela ao tocar em uma aba
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Meus Veículos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Adicionar Veículo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // Método que retorna a tela correspondente ao índice selecionado
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const MeusVeiculosView();
      case 2:
        return AddVehicleView();
      case 3:
        return const HistoricoAbastecimentoView(
            vehicleId: ''); // Passe o vehicleId conforme necessário
      case 4:
        return const ProfileView();
      default:
        return const HomeView(); // Tela padrão
    }
  }
}
