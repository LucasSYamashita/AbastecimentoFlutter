import 'package:flutter/material.dart';

class EditVehicleView extends StatelessWidget {
  final String vehicleId;

  EditVehicleView({required this.vehicleId});

  final nomeController = TextEditingController();
  final modeloController = TextEditingController();
  final anoController = TextEditingController();
  final placaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
                controller: nomeController,
                decoration: InputDecoration(hintText: 'Nome do Veículo')),
            SizedBox(height: 16),
            TextField(
                controller: modeloController,
                decoration: InputDecoration(hintText: 'Modelo')),
            SizedBox(height: 16),
            TextField(
                controller: anoController,
                decoration: InputDecoration(hintText: 'Ano')),
            SizedBox(height: 16),
            TextField(
                controller: placaController,
                decoration: InputDecoration(hintText: 'Placa')),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Lógica para salvar as alterações no veículo
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veículo atualizado com sucesso!')));
                Navigator.pop(context);
              },
              child: Text('Salvar Alterações'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para excluir o veículo
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Excluir Veículo'),
                    content:
                        Text('Tem certeza que deseja excluir este veículo?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Excluir o veículo
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Veículo excluído!')));
                          Navigator.pop(context);
                        },
                        child: Text('Excluir'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Excluir Veículo'),
            ),
          ],
        ),
      ),
    );
  }
}
