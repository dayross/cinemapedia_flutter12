import 'package:cinemapedia_flutter12/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia_flutter12/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// "provider" es un proveedor de información
// nombre del repositorio que estoy proveyendo

// este repositorio es INMUTABLE, es de solo lectura, solo da información

final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MovieDBDataSource());
});
