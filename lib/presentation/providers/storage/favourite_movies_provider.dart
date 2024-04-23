import 'dart:typed_data';

import 'package:cinemapedia_flutter12/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia_flutter12/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

final favouriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final LocalStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: LocalStorageRepository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<void> loadNextPage() async {
    // llamamos el provider que no de mas peliculas
    final movies = await localStorageRepository.loadMovies(offset: page * 10);
    // TODO LIMIT 20
    // aumentamos numero de pagina
    page++;

    // creamos mapa de peliculas y sus ids y lo guardamos ahi
    final tempMoviesMap = <int, Movie>{};

    for (final movie in movies) {
      // por cada pelicula que nos traiga el provider la guardamos aqui
      tempMoviesMap[movie.id] = movie;
    }

    // agregamos la lista al estado
    state = {...state, ...tempMoviesMap};
  }
}
