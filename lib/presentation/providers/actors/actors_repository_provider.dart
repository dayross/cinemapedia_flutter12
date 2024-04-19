import 'package:cinemapedia_flutter12/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia_flutter12/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// "provider" es un proveedor de información
// nombre del repositorio que estoy proveyendo

// este repositorio es INMUTABLE, es de solo lectura, solo da información

final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(ActorMovieDBDatasource());
});
