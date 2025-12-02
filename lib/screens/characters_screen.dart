import 'package:flutter/material.dart';
import '../model/personaje.dart'; // ajusta la ruta si tu modelo está en otra carpeta

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Aquí deberás obtener los datos del provider.
    // Ejemplo orientativo (NO lo uses literal si tu provider se llama distinto):
    //
    // final characters = context.watch<CharactersProvider>().items;
    //
    // De momento, hacemos una lista dummy vacía:
    final List<Personaje> characters = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: characters.isEmpty
            ? const Center(
                child: Text(
                  'No hay personajes cargados.\nConecta aquí tu provider.',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.separated(
                itemCount: characters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return _CharacterCard(character: character);
                },
              ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Personaje character;

  const _CharacterCard({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del personaje
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                character.image,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 12),
            // Info básica
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${character.race} · ${_genderToText(character.gender)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ki: ${character.ki} / ${character.maxKi}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Afiliación: ${_affiliationToText(character.affiliation)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _genderToText(Gender gender) {
    switch (gender) {
      case Gender.MALE:
        return 'Masculino';
      case Gender.FEMALE:
        return 'Femenino';
    }
  }

  String _affiliationToText(Affiliation affiliation) {
    switch (affiliation) {
      case Affiliation.Z_FIGHTER:
        return 'Z Fighter';
      case Affiliation.ARMY_OF_FRIEZA:
        return 'Ejército de Freezer';
      case Affiliation.FREELANCER:
        return 'Freelancer';
    }
  }
}
