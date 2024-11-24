import 'package:abastecimentoflutter/views/screens/addveiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeusVeiculosView extends StatefulWidget {
  const MeusVeiculosView({Key? key}) : super(key: key);

  @override
  State<MeusVeiculosView> createState() => _MeusVeiculosViewState();
}

class _MeusVeiculosViewState extends State<MeusVeiculosView> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Veículos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('veiculos')
            .where('usuarioId',
                isEqualTo: user?.uid) // Filtra veículos do usuário logado
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar veículos.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum veículo cadastrado.'));
          }

          final veiculos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              final veiculo = veiculos[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(veiculo['nome']),
                  subtitle: Text('Placa: ${veiculo['placa']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool? confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar Exclusão'),
                          content: const Text(
                              'Você tem certeza que deseja excluir este veículo?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        await FirebaseFirestore.instance
                            .collection('veiculos')
                            .doc(veiculo.id)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Veículo excluído com sucesso.')),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ao clicar no botão flutuante, leva para a tela de adicionar novo veículo
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddVehicleView()), // Chama a tela correta para adicionar veículo
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
