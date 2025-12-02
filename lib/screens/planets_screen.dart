import 'package:flutter/material.dart';

class PlanetsScreen extends StatelessWidget {
  const PlanetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: conectar con el provider / servicio de planetas cuando lo tengas.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planetas'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Pantalla de planetas\n\n'
            'Aquí mostraremos la lista de planetas de la API de Dragon Ball.\n'
            'De momento es solo una plantilla.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
