// ignore_for_file: prefer_const_constructors

import 'package:cinemapedia_flutter12/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia_flutter12/presentation/providers/providers.dart';

import '../../../domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool isLoading = false;

// PROVIDERS ******

// adentro de los <> primero va la clase que controla al provider y despues lo que regresa
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});


// FIN PROVIDERS *****



typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  // inicializamos el constructor con un arreglo vacio
  int currentPage = 0;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]);




  Future<void> loadNextPage() async {
    // TODO : modifique la función que hace que no se
    // envien tantas peticiones al mismo tiempo ya que
    // no me cargaba de esa manera para las demas peliculas
    //hay que ajustarla para evitar el envio de peticiones multiples
    if (isLoading) return;

    isLoading = true;
    print('loading more movies');
    currentPage++;
    isLoading = false;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    
    await Future.delayed(Duration(seconds: 1));
    
  }
}
