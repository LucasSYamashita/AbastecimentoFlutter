import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NovoAbastecimentoView extends StatefulWidget {
  final String vehicleId;

  const NovoAbastecimentoView({super.key, required this.vehicleId});

  @override
  _NovoAbastecimentoViewState createState() => _NovoAbastecimentoViewState();
}

class _NovoAbastecimentoViewState extends State<NovoAbastecimentoView> {
  final _litrosController = TextEditingController();
  final _quilometragemController = TextEditingController();
  final _dataController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Método para construir os campos de entrada
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  // Método para enviar o formulário
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Salvar o abastecimento no Firestore
        await FirebaseFirestore.instance.collection('abastecimentos').add({
          'vehicleId': widget.vehicleId,
          'litros': double.parse(_litrosController.text),
          'quilometragem': int.parse(_quilometragemController.text),
          'data': _dataController.text,
          'usuarioId': FirebaseAuth.instance.currentUser!.uid,
          'timestamp': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Abastecimento registrado com sucesso!')),
        );

        // Voltar para a tela anterior
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar abastecimento: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Abastecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _litrosController,
                hintText: 'Quantidade de Litros',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _quilometragemController,
                hintText: 'Quilometragem Atual',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _dataController,
                hintText: 'Data (dd/mm/aaaa)',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrar Abastecimento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
