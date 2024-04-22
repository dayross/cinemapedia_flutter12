import 'package:cinemapedia_flutter12/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia_flutter12/domain/entities/actor.dart';
import 'package:cinemapedia_flutter12/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDataSource datasource;

  ActorRepositoryImpl(this.datasource);

  @override
  Future<List<Actor>> getActorsByMovie(String movieID) {
    return datasource.getActorsByMovie(movieID);
  }
}
