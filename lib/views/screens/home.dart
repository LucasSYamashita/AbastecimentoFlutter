import 'package:abastecimentoflutter/views/screens/addveiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  Future<List<Map<String, dynamic>>> _carregarVeiculos() async {
    if (uid == null) return [];
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('veiculos')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'nome': data['nome'] ?? '',
          'modelo': data['modelo'] ?? '',
          'placa': data['placa'] ?? '',
        };
      }).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar veículos')),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Veículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdicionarVeiculoView(),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _carregarVeiculos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar veículos'));
          }

          final veiculos = snapshot.data ?? [];
          if (veiculos.isEmpty) {
            return const Center(child: Text('Nenhum veículo cadastrado'));
          }

          return ListView.builder(
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              final veiculo = veiculos[index];
              return ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text(veiculo['nome']),
                subtitle: Text('${veiculo['modelo']} - ${veiculo['placa']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AdicionarVeiculoView(vehicleId: veiculo['id']),
                    ),
                  ).then((_) => setState(() {}));
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _excluirVeiculo(veiculo['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _excluirVeiculo(String vehicleId) async {
    if (uid == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('veiculos')
          .doc(vehicleId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veículo excluído com sucesso')),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir veículo')),
      );
    }
  }
}
