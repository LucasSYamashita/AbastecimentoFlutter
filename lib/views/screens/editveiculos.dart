import 'package:flutter/material.dart';

class EditVehicleView extends StatelessWidget {
  final String vehicleId;

  EditVehicleView({super.key, required this.vehicleId});

  final nomeController = TextEditingController();
  final modeloController = TextEditingController();
  final anoController = TextEditingController();
  final placaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
                controller: nomeController,
                decoration: const InputDecoration(hintText: 'Nome do Veículo')),
            const SizedBox(height: 16),
            TextField(
                controller: modeloController,
                decoration: const InputDecoration(hintText: 'Modelo')),
            const SizedBox(height: 16),
            TextField(
                controller: anoController,
                decoration: const InputDecoration(hintText: 'Ano')),
            const SizedBox(height: 16),
            TextField(
                controller: placaController,
                decoration: const InputDecoration(hintText: 'Placa')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Lógica para salvar as alterações no veículo
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Veículo atualizado com sucesso!')));
                Navigator.pop(context);
              },
              child: const Text('Salvar Alterações'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para excluir o veículo
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Excluir Veículo'),
                    content: const Text(
                        'Tem certeza que deseja excluir este veículo?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Excluir o veículo
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Veículo excluído!')));
                          Navigator.pop(context);
                        },
                        child: const Text('Excluir'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Excluir Veículo'),
            ),
          ],
        ),
      ),
    );
  }
}
