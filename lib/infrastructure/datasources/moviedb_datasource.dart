// Este datasource solo va a tener interacciones con la API de TheMovieDB.
// En el dado caso que se necesiten interacciones con demas APIs, se crearán
// más archivos como este pero dirigidos a las demas fuentes de datos.

import 'package:cinemapedia_flutter12/config/constants/environment.dart';
import 'package:cinemapedia_flutter12/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia_flutter12/infrastructure/models/movie_db/movie_details.dart';
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

  List<Movie> _jsonToMovie(Map<String, dynamic> json) {
    final movieDBresponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDBresponse.results
        .map((moviedb) => MovieMapper.movieDBtoEntity(moviedb))
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});
    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});
    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response =
        await dio.get('/movie/top_rated', queryParameters: {'page': page});
    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});
    return _jsonToMovie(response.data);
  }


  @override
  Future<Movie> getMovieByID(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) throw Exception('Movie not found');

    final movieDetails = MovieDetails.fromJson(response.data);

    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);
    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {
    final response =
        await dio.get('/search/movie', queryParameters: {'query': query});
    return _jsonToMovie(response.data);
  }
}
