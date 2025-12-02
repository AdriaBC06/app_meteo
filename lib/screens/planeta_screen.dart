import 'package:flutter/material.dart';

class PlanetaScreen extends StatelessWidget {
  const PlanetaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planeta'),
      ),
      body: const Center(
        child: Text(
          'Pantalla de Planeta',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
