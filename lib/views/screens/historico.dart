import 'package:flutter/material.dart';

class HistoricoAbastecimentoView extends StatelessWidget {
  final String vehicleId;

  const HistoricoAbastecimentoView({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Abastecimentos'),
      ),
      body: Center(
        child: Text('Histórico de abastecimento para o veículo: $vehicleId'),
      ),
    );
  }
}
