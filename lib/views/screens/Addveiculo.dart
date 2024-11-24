import 'package:flutter/material.dart';

class AddVehicleView extends StatelessWidget {
  final nomeController = TextEditingController();
  final modeloController = TextEditingController();
  final anoController = TextEditingController();
  final placaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(hintText: 'Nome do Veículo'),
                validator: (value) =>
                    value!.isEmpty ? 'Nome obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: modeloController,
                decoration: InputDecoration(hintText: 'Modelo'),
                validator: (value) =>
                    value!.isEmpty ? 'Modelo obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: anoController,
                decoration: InputDecoration(hintText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ano obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: placaController,
                decoration: InputDecoration(hintText: 'Placa'),
                validator: (value) =>
                    value!.isEmpty ? 'Placa obrigatória' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Aqui você pode adicionar a lógica para salvar no Firebase
                    // Exemplo: salvar o veículo em Firestore
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Veículo cadastrado com sucesso!')));
                    Navigator.pop(context);
                  }
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
