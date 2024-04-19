import '../entities/actor.dart';

abstract class ActorsDataSource {
  
  Future<List<Actor>> getActorsByMovie(String movieID);


}
