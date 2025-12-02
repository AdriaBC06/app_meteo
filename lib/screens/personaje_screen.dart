import 'package:flutter/material.dart';

class PersonajeScreen extends StatelessWidget {
  const PersonajeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personaje'),
      ),
      body: const Center(
        child: Text(
          'Pantalla de Personaje',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
