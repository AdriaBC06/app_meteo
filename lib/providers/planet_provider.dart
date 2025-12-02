import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';
import '../model/planet.dart';
import '../services/api_services.dart';

final planetsProvider = AsyncNotifierProvider<PlanetsNotifier, List<PlanetItem>>(PlanetsNotifier.new);

class PlanetsNotifier extends AsyncNotifier<List<PlanetItem>> {
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<PlanetItem>> build() => _fetch(1, refresh: true);

  Future<List<PlanetItem>> _fetch(int page, {bool refresh = false}) async {
    if (!_hasMore && !refresh) return [];
    final api = ref.read(apiServiceProvider as ProviderListenable);
    final data = await api.get('planets', params: {'page': '$page', 'limit': '20'});
    final response = Planets.fromMap(data);
    _hasMore = response.links.next?.isNotEmpty ?? false;
    if (_hasMore) _page = page + 1;
    return response.items;
  }

  Future<void> loadMore() async {
    if (state.isLoading || !_hasMore) return;
    final current = state.value ?? [];
    state = AsyncData([...current, ...await _fetch(_page)]);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetch(1, refresh: true));
  }
}