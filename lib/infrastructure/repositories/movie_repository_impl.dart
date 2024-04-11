import 'package:cinemapedia_flutter12/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia_flutter12/domain/entities/movie.dart';
import 'package:cinemapedia_flutter12/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDataSource datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return this.datasource.getNowPlaying(page: page);
  }
}
