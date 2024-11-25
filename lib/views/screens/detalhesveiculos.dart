import 'package:abastecimentoflutter/views/screens/novoabastecimento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetalhesVeiculoView extends StatefulWidget {
  final String vehicleId;

  const DetalhesVeiculoView({Key? key, required this.vehicleId})
      : super(key: key);

  @override
  State<DetalhesVeiculoView> createState() => _DetalhesVeiculoViewState();
}

class _DetalhesVeiculoViewState extends State<DetalhesVeiculoView> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchVehicleDetails() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("Usuário não logado");
    }
    return db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .doc(widget.vehicleId)
        .get();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchRefuels() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      return [];
    }
    final refuelsSnapshot = await db
        .collection('usuarios')
        .doc(uid)
        .collection('veiculos')
        .doc(widget.vehicleId)
        .collection('abastecimentos')
        .orderBy('data', descending: true)
        .get();

    return refuelsSnapshot.docs;
  }

  double _calculateAvg(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> refuels) {
    if (refuels.length < 2) return 0.0;

    final lastKilometers = refuels[0]['quilometragem'];
    final previousKilometers = refuels[1]['quilometragem'];
    final lastLiters = refuels[0]['litros'];

    return (lastKilometers - previousKilometers) / lastLiters;
  }

  void _adicionarAbastecimento() {
    print("Navegando para a tela de adicionar abastecimento...");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NovoAbastecimentoView(vehicleId: widget.vehicleId),
      ),
    ).then((_) {
      print("Voltando de NovoAbastecimentoView, recarregando os dados...");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_fetchVehicleDetails(), _fetchRefuels()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Erro ao carregar os dados do veículo.')),
          );
        }

        final vehicle = snapshot.data![0].data();
        final refuels = snapshot.data![1]
            as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

        final avgConsumption =
            refuels.length >= 2 ? _calculateAvg(refuels) : 0.0;

        return Scaffold(
          appBar: AppBar(
            title: Text(
                '${vehicle['nome']} ${vehicle['modelo']} ${vehicle['ano']}'),
          ),
          body: Column(
            children: [
              _makeInfo('Placa', vehicle['placa']),
              if (avgConsumption > 0.0)
                Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 4,
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Consumo Médio",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${avgConsumption.toStringAsFixed(2)} Km/L",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              const Divider(thickness: 2, color: Colors.orange),
              Expanded(
                child: ListView.builder(
                  itemCount: refuels.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton.icon(
                          onPressed: _adicionarAbastecimento,
                          icon: const Icon(Icons.add),
                          label: const Text("Adicionar Abastecimento"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      );
                    }
                    final refuel = refuels[index - 1];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                            "Data: ${(refuel['data'] as Timestamp).toDate()}"),
                        subtitle: Text(
                            "Litros: ${refuel['litros']} | Quilometragem: ${refuel['quilometragem']}"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _makeInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
