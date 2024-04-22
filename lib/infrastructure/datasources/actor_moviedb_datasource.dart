import 'package:cinemapedia_flutter12/config/constants/environment.dart';
import 'package:cinemapedia_flutter12/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia_flutter12/domain/entities/actor.dart';
import 'package:cinemapedia_flutter12/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia_flutter12/infrastructure/models/movie_db/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDBDatasource extends ActorsDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3/movie',
    queryParameters: {'language': 'es-MX', 'api_key': Environment.movieDBkey},
  ));

  @override
  Future<List<Actor>> getActorsByMovie(String movieID) async {
    // hacemos la peticion con dio
    final response = await dio.get('/$movieID/credits');
    // pasamos la respuerta al convertidor desde json
    final castResponse = CreditsResponse.fromJson(response.data);
    // convertimos esa respuesta a una lista de actores con ayuda
    //del map
    List<Actor> actors = castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();
    return actors;
  }
}
