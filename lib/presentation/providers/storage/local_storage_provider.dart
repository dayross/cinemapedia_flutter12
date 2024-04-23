import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia_flutter12/infrastructure/datasources/isar_datasource.dart';
import 'package:cinemapedia_flutter12/infrastructure/repositories/local_storage_repository_impl.dart';

// provider inmutbable
final localStorageRepositoryProvider = Provider((ref) {
  // devolvemos la fuente de datos local
  return LocalStorageRepositoryImpl(IsarDatasource());
});
