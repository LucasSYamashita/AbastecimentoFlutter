import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tela Principal - Home',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
