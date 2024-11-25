import 'package:abastecimentoflutter/views/screens/detalhesveiculos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdicionarVeiculoView extends StatefulWidget {
  final String? vehicleId;

  const AdicionarVeiculoView({Key? key, this.vehicleId}) : super(key: key);

  @override
  State<AdicionarVeiculoView> createState() => _AdicionarVeiculoViewState();
}

class _AdicionarVeiculoViewState extends State<AdicionarVeiculoView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _modeloController = TextEditingController();
  final _placaController = TextEditingController();
  final _anoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.vehicleId != null) {
      _carregarDadosVeiculo();
    }
  }

  Future<void> _carregarDadosVeiculo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || widget.vehicleId == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('veiculos')
          .doc(widget.vehicleId)
          .get();

      if (doc.exists) {
        final veiculo = doc.data();
        _nomeController.text = veiculo?['nome'] ?? '';
        _modeloController.text = veiculo?['modelo'] ?? '';
        _placaController.text = veiculo?['placa'] ?? '';
        _anoController.text = veiculo?['ano']?.toString() ?? '';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados do veículo não encontrados!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar dados do veículo!')),
      );
    }
  }

  Future<void> _salvarVeiculo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final veiculoData = {
      'nome': _nomeController.text.trim(),
      'modelo': _modeloController.text.trim(),
      'placa': _placaController.text.trim(),
      'ano': int.tryParse(_anoController.text.trim()) ?? 0,
    };

    String? newVehicleId = widget.vehicleId;

    try {
      if (widget.vehicleId != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('veiculos')
            .doc(widget.vehicleId)
            .update(veiculoData);
      } else {
        final docRef = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('veiculos')
            .add(veiculoData);
        newVehicleId = docRef.id;
      }

      if (newVehicleId != null && newVehicleId.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesVeiculoView(
              vehicleId: newVehicleId!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar o veículo!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o veículo!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vehicleId == null ? 'Adicionar Veículo' : 'Editar Veículo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Modelo é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Placa é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ano é obrigatório';
                  }
                  final ano = int.tryParse(value);
                  if (ano == null || ano < 1886 || ano > DateTime.now().year) {
                    return 'Ano inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _salvarVeiculo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                ),
                child: Text(widget.vehicleId == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
