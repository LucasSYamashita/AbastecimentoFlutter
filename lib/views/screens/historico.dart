import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoricoAbastecimentoView extends StatefulWidget {
  const HistoricoAbastecimentoView({Key? key}) : super(key: key);

  @override
  State<HistoricoAbastecimentoView> createState() =>
      _HistoricoAbastecimentoViewState();
}

class _HistoricoAbastecimentoViewState
    extends State<HistoricoAbastecimentoView> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> _fetchRefuelHistory() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      return [];
    }

    final vehiclesSnapshot =
        await db.collection('usuarios').doc(uid).collection('veiculos').get();

    List<Map<String, dynamic>> allRefuels = [];

    for (var vehicle in vehiclesSnapshot.docs) {
      final vehicleId = vehicle.id;
      final vehicleName = vehicle['nome'];
      final vehicleModel = vehicle['modelo'];

      final refuelsSnapshot = await db
          .collection('usuarios')
          .doc(uid)
          .collection('veiculos')
          .doc(vehicleId)
          .collection('abastecimentos')
          .orderBy('data', descending: true)
          .get();

      for (var refuel in refuelsSnapshot.docs) {
        final refuelData = refuel.data();
        refuelData['vehicleName'] = vehicleName;
        refuelData['vehicleModel'] = vehicleModel;
        allRefuels.add(refuelData);
      }
    }

    return allRefuels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Abastecimentos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchRefuelHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar abastecimentos.'),
            );
          }

          final refuels = snapshot.data ?? [];

          if (refuels.isEmpty) {
            return const Center(
              child: Text('Nenhum abastecimento registrado.'),
            );
          }

          return ListView.builder(
            itemCount: refuels.length,
            itemBuilder: (context, index) {
              final refuel = refuels[index];
              final litros = refuel['litros'];
              final quilometragem = refuel['quilometragem'];
              final data = (refuel['data'] as Timestamp).toDate();
              final vehicleName = refuel['vehicleName'];
              final vehicleModel = refuel['vehicleModel'];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Data: ${data.toLocal()}"),
                  subtitle: Text(
                      "Veículo: $vehicleName $vehicleModel\nLitros: $litros | Quilometragem: $quilometragem"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
