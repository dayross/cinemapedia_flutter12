// Este datasource solo va a tener interacciones con la API de TheMovieDB.
// En el dado caso que se necesiten interacciones con demas APIs, se crearán
// más archivos como este pero dirigidos a las demas fuentes de datos.

import 'package:cinemapedia_flutter12/config/constants/environment.dart';
import 'package:cinemapedia_flutter12/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia_flutter12/infrastructure/models/movie_db/moviedb_response.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia_flutter12/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia_flutter12/domain/entities/movie.dart';

class MovieDBDataSource extends MoviesDataSource {
  //https://api.themoviedb.org/3/movie/now_playing
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {'language': 'es-MX', 'api_key': Environment.movieDBkey},
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');

    final movieDBresponse = MovieDbResponse.fromJson(response.data);
    final List<Movie> movies = movieDBresponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBtoEntity(moviedb))
        .toList();
    return movies;
  }
}
