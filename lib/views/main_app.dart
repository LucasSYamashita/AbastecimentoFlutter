import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:abastecimentoflutter/views/screens/home.dart';
import 'package:abastecimentoflutter/views/screens/meusveiculos.dart';
import 'package:abastecimentoflutter/views/screens/addveiculo.dart';
import 'package:abastecimentoflutter/views/screens/historico.dart';
import 'package:abastecimentoflutter/views/screens/perfil.dart';
import 'package:abastecimentoflutter/widgets/custom_drawer.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Abastecimento'),
      ),
      drawer: CustomDrawer(onItemTapped: _onItemTapped),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.orange,
        onTap: _onItemTapped,
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

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeView();
      case 1:
        return MeusVeiculosView();
      case 2:
        return AdicionarVeiculoView();
      case 3:
        return HistoricoAbastecimentoView();
      case 4:
        return PerfilView();
      default:
        return HomeView();
    }
  }
}
