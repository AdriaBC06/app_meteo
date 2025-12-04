// providers/planets_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/planet.dart';
import '../services/api_services.dart';

final planetsProvider = 
    AsyncNotifierProvider<PlanetsNotifier, List<PlanetItem>>(PlanetsNotifier.new);

class PlanetsNotifier extends AsyncNotifier<List<PlanetItem>> {
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<PlanetItem>> build() async {
    return _fetchPage(1);
  }

  Future<List<PlanetItem>> _fetchPage(int page) async {
    final api = ref.read(apiServiceProvider);
    final data = await api.get('planets', params: {
      'page': page.toString(),
      'limit': '20',
    });

    final response = Planets.fromMap(data);
    _hasMore = (response.links.next).isNotEmpty;
    if (_hasMore) _page = page + 1;

    return response.items;
  }

  Future<void> loadMore() async {
    if (state.isLoading || !_hasMore) return;

    final current = state.value ?? [];
    final newItems = await _fetchPage(_page);
    state = AsyncData([...current, ...newItems]);
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = AsyncData(await _fetchPage(1));
  }
}