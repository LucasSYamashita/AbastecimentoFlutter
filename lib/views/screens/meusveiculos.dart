import 'package:flutter/material.dart';

class Vehicle {
  final String nome;
  final String modelo;
  final String ano;
  final String placa;

  Vehicle(
      {required this.nome,
      required this.modelo,
      required this.ano,
      required this.placa});
}

class MyVehiclesView extends StatelessWidget {
  final List<Vehicle> vehicles = [
    Vehicle(
        nome: 'Carro 1', modelo: 'Modelo A', ano: '2020', placa: 'ABC-1234'),
    Vehicle(
        nome: 'Carro 2', modelo: 'Modelo B', ano: '2021', placa: 'XYZ-5678'),
    Vehicle(
        nome: 'Carro 3', modelo: 'Modelo C', ano: '2019', placa: 'JKL-9101'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Veículos')),
      body: vehicles.isEmpty
          ? Center(child: Text('Nenhum veículo cadastrado.'))
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                Vehicle vehicle = vehicles[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.directions_car, color: Colors.orange),
                    title: Text(vehicle.nome,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Modelo: ${vehicle.modelo}'),
                        Text('Ano: ${vehicle.ano}'),
                        Text('Placa: ${vehicle.placa}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditVehicleView(vehicleId: 'veículo_id')),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditVehicleView(vehicleId: 'veículo_id')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class EditVehicleView extends StatelessWidget {
  final String vehicleId;
  EditVehicleView({required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Veículo')),
      body: Center(child: Text('Tela de edição para o veículo $vehicleId')),
    );
  }
}
