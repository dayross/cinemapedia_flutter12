import 'package:cinemapedia_flutter12/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/movie.dart';

// hacemos un provider en el cual estamos obteniendo una referencia
// a nuestra funcion getMovieById
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);

  return MovieMapNotifier(getMovie: movieRepository.getMovieByID);
});

// definimos un tipo de dato que es igual a una funcion que nos solicita un movieId
// y que nos regresa un Future de tipo Movie

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    print('Realizando peticion http');
    final movie = await getMovie(movieId);

    state = {...state, movieId: movie};
  }
}
