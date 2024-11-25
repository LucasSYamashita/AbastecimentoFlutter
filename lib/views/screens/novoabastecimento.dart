import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NovoAbastecimentoView extends StatefulWidget {
  final String vehicleId;

  const NovoAbastecimentoView({Key? key, required this.vehicleId})
      : super(key: key);

  @override
  _NovoAbastecimentoViewState createState() => _NovoAbastecimentoViewState();
}

class _NovoAbastecimentoViewState extends State<NovoAbastecimentoView> {
  final _formKey = GlobalKey<FormState>();
  final _litrosController = TextEditingController();
  final _quilometragemController = TextEditingController();

  Future<void> _salvarAbastecimento() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado')),
      );
      return;
    }

    final litros = double.tryParse(_litrosController.text);
    final quilometragem = int.tryParse(_quilometragemController.text);

    if (litros == null || quilometragem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('veiculos')
          .doc(widget.vehicleId)
          .collection('abastecimentos')
          .add({
        'litros': litros,
        'quilometragem': quilometragem,
        'data': FieldValue.serverTimestamp(),
        'vehicleId': widget.vehicleId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abastecimento registrado com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar abastecimento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Abastecimento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _litrosController,
                decoration: const InputDecoration(labelText: 'Litros'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade de litros';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quilometragemController,
                decoration: const InputDecoration(labelText: 'Quilometragem'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quilometragem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _salvarAbastecimento();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Salvar Abastecimento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
