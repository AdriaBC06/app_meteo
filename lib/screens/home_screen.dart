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
    // Usamos el argument como nombre de usuario
    final args = ModalRoute.of(context)?.settings.arguments;
    final String username =
        (args is String && args.isNotEmpty) ? args : 'Usuari';

    final charactersAsync = ref.watch(charactersProvider);
    final planetsAsync = ref.watch(planetsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE7F0FA), // fondo clarito rollo Wii
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Barra superior con usuario y logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        child: Icon(Icons.person),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Connectat',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.power_settings_new),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('logOrReg');
                    },
                  )
                ],
              ),
            ),

            // Título estilo menú Wii
            const Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Text(
                'Menú principal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // "Canales" Wii para cambiar de sección
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 140,
                child: Row(
                  children: [
                    Expanded(
                      child: _WiiChannelTile(
                        title: 'Personatges',
                        icon: Icons.person,
                        selected:
                            _selectedSection == SelectedSection.characters,
                        onTap: () {
                          setState(() {
                            _selectedSection = SelectedSection.characters;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _WiiChannelTile(
                        title: 'Planetes',
                        icon: Icons.public,
                        selected:
                            _selectedSection == SelectedSection.planets,
                        onTap: () {
                          setState(() {
                            _selectedSection = SelectedSection.planets;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Contenido de la sección seleccionada
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedSection == SelectedSection.characters
                      ? _buildCharactersGrid(charactersAsync)
                      : _buildPlanetsGrid(planetsAsync),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // GRID DE PERSONAJES COMO CANALES WII
  Widget _buildCharactersGrid(AsyncValue<List<Item>> asyncCharacters) {
    return Container(
      key: const PageStorageKey('charactersContainer'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Colors.black12,
          ),
        ],
      ),
      child: asyncCharacters.when(
        data: (characters) {
          if (characters.isEmpty) {
            return const Center(child: Text('No s\'han trobat personatges'));
          }
          return GridView.builder(
            key: const PageStorageKey('charactersGrid'),
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,       // 2 canales por fila
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4, // más alto que ancho
            ),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];

              final imageUrl = (character.image.isNotEmpty)
                  ? character.image
                  : 'https://placehold.co/256x256?text=DBZ';

              return _WiiContentCard(
                title: character.name,
                subtitle:
                    'Ki: ${character.ki} / ${character.maxKi}\n${character.race}',
                imageUrl: imageUrl,
                onTap: () {
                  // Detalle personaje
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text('Error carregant personatges: $e'),
        ),
      ),
    );
  }

  // GRID DE PLANETAS COMO CANALES WII
  Widget _buildPlanetsGrid(AsyncValue<List<PlanetItem>> asyncPlanets) {
    return Container(
      key: const PageStorageKey('planetsContainer'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Colors.black12,
          ),
        ],
      ),
      child: asyncPlanets.when(
        data: (planets) {
          if (planets.isEmpty) {
            return const Center(child: Text('No s\'han trobat planetes'));
          }
          return GridView.builder(
            key: const PageStorageKey('planetsGrid'),
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemCount: planets.length,
            itemBuilder: (context, index) {
              final planet = planets[index];

              final imageUrl =
                  planet.image.isNotEmpty ? planet.image : '';

              return _WiiContentCard(
                title: planet.name,
                subtitle: 'ID: ${planet.id}',
                imageUrl: imageUrl,
                onTap: () {
                  // Detalle planeta
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text('Error carregant planetes: $e'),
        ),
      ),
    );
  }
}

/// Widget para los "canales" de selección (Personajes / Planetas)
class _WiiChannelTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _WiiChannelTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = selected ? Colors.lightBlue[200] : Colors.white;
    final borderColor =
        selected ? Colors.lightBlueAccent : Colors.grey.shade300;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: borderColor,
            width: selected ? 3 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 4),
              color: Colors.black12,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de contenido estilo canal de Wii (imagen grande + texto)
class _WiiContentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onTap;

  const _WiiContentCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // IMAGEN SIN RECORTAR
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: hasImage
                      ? Center(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain, // 👈 no recorta
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image,
                              size: 60,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
