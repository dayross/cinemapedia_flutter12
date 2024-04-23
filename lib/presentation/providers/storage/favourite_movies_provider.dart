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

  Future<List<Movie>> loadNextPage() async {
    // llamamos el provider que no de mas peliculas
    final movies =
        await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
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

    await Future.delayed(const Duration(seconds: 1));

    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    // va a la BD y saca/mete la pelicula a la BD
    await localStorageRepository.toggleFavorite(movie);

    final bool isMovieInFavs = state[movie.id] != null;
    if (isMovieInFavs) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }
}
