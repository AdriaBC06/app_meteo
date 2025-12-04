import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../model/personaje.dart';
import '../model/planet.dart';

enum SelectedSection { characters, planets }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  SelectedSection _selectedSection = SelectedSection.characters;

  @override
  Widget build(BuildContext context) {
    // ⚠️ Evitar null al recibir argumentos
    final args = ModalRoute.of(context)?.settings.arguments;
    final String missatge =
        (args is String && args.isNotEmpty) ? args : 'Benvingut/da!';

    final charactersAsync = ref.watch(charactersProvider);
    final planetsAsync = ref.watch(planetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inici'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('logOrReg');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          // Mensaje
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              missatge,
              style: const TextStyle(
                fontSize: 24.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          // Botones para cambiar de sección
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedSection = SelectedSection.characters;
                      });
                    },
                    icon: const Icon(Icons.person),
                    label: const Text('Personajes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedSection == SelectedSection.characters
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedSection = SelectedSection.planets;
                      });
                    },
                    icon: const Icon(Icons.public),
                    label: const Text('Planetas'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedSection == SelectedSection.planets
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Lista que ocupa el resto de la pantalla
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedSection == SelectedSection.characters
                  ? _buildCharactersList(charactersAsync)
                  : _buildPlanetsList(planetsAsync),
            ),
          ),
        ],
      ),
    );
  }

  // LISTA DE PERSONAJES
  Widget _buildCharactersList(AsyncValue<List<Item>> asyncCharacters) {
    return asyncCharacters.when(
      data: (characters) {
        if (characters.isEmpty) {
          return const Center(child: Text('No s\'han trobat personatges'));
        }
        return ListView.builder(
          key: const PageStorageKey('charactersList'),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];

            final imageUrl = (character.image.isNotEmpty)
                ? character.image
                : 'https://placehold.co/128x128?text=DBZ';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person),
                  ),
                ),
                title: Text(character.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ki: ${character.ki} / ${character.maxKi}'),
                    Text('Raza: ${character.race}'),
                    Text(
                      'Afiliación: '
                      '${affiliationValues.reverse[character.affiliation]}',
                    ),
                  ],
                ),
                isThreeLine: true,
                onTap: () {
                  // Detalle personaje
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text('Error carregant personatges: $e'),
      ),
    );
  }

  // LISTA DE PLANETAS
  // LISTA DE PLANETAS
  Widget _buildPlanetsList(AsyncValue<List<PlanetItem>> asyncPlanets) {
    return asyncPlanets.when(
      data: (planets) {
        if (planets.isEmpty) {
          return const Center(child: Text('No s\'han trobat planetes'));
        }
        return ListView.builder(
          key: const PageStorageKey('planetsList'),
          itemCount: planets.length,
          itemBuilder: (context, index) {
            final planet = planets[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: planet.image.isNotEmpty
                      ? Image.network(
                          planet.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          // Por si la URL falla o está rota
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.public, size: 40),
                        )
                      : const Icon(Icons.public, size: 40),
                ),
                title: Text(planet.name),
                subtitle: Text('ID: ${planet.id}'),
                onTap: () {
                  // Detalle planeta
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text('Error carregant planetes: $e'),
      ),
    );
  }
}
