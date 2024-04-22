import 'package:cinemapedia_flutter12/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);
  return SearchedMoviesNotifier(
      ref: ref, searchedMovies: movieRepository.searchMovies);
});

typedef searchedMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  final searchedMoviesCallback searchedMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.ref,
    required this.searchedMovies,
  }) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchedMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
