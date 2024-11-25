import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetalhesVeiculoView extends StatelessWidget {
  final String vehicleId;

  const DetalhesVeiculoView({Key? key, required this.vehicleId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Usuário não autenticado.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Veículo')),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('usuarios')
                .doc(uid)
                .collection('veiculos')
                .doc(vehicleId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar detalhes.'));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('Veículo não encontrado.'));
              }

              final veiculo = snapshot.data!;
              return ListTile(
                title: Text('Nome: ${veiculo['nome']}'),
                subtitle: Text('Modelo: ${veiculo['modelo']}'),
                trailing: Text('Placa: ${veiculo['placa']}'),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditarVeiculoView(vehicleId: vehicleId),
                    ),
                  );
                },
                child: const Text('Editar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  bool? confirmDelete =
                      await _showDeleteConfirmationDialog(context);
                  if (confirmDelete == true) {
                    await _deleteVehicle(context, uid);
                  }
                },
                child: const Text('Excluir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(uid)
                  .collection('veiculos')
                  .doc(vehicleId)
                  .collection('abastecimentos')
                  .orderBy('data', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar abastecimentos.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Nenhum abastecimento registrado.'));
                }

                final abastecimentos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: abastecimentos.length,
                  itemBuilder: (context, index) {
                    final abastecimento = abastecimentos[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('Litros: ${abastecimento['litros']}'),
                        subtitle: Text(
                          'Quilometragem: ${abastecimento['quilometragem']} - Data: ${abastecimento['data'].toDate()}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Veículo'),
          content:
              const Text('Tem certeza de que deseja excluir este veículo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteVehicle(BuildContext context, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('veiculos')
          .doc(vehicleId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veículo excluído com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir o veículo: $e')),
      );
    }
  }
}

class EditarVeiculoView extends StatelessWidget {
  final String vehicleId;

  const EditarVeiculoView({Key? key, required this.vehicleId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Veículo'),
      ),
      body: const Center(
        child: Text('Tela de edição de veículo'),
      ),
    );
  }
}
