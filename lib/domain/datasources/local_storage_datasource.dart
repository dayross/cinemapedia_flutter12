import '../entities/movie.dart';

abstract class LocalStorageDataSource {
  Future<void> toggleFavorite(Movie movie);

  Future<void> isMovieFavorite(int movieID);

  Future<List<Movie>> loadMovies({int limit, offset = 0});
}
