import 'package:isar/isar.dart';
import 'package:cinemapedia_flutter12/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia_flutter12/domain/entities/movie.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDataSource {
  // va a ser late debido a que becesitamos esperar que la bd esta lista para conexions
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([MovieSchema], directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieID) async {
    final isar = await db;

    final Movie? isFavMovie =
        await isar.movies.filter().idEqualTo(movieID).findFirst();
    if (isFavMovie != null) print('la pelicula esta en la bd como fav');
    return isFavMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie != null) {
      // borrar
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      print('borrando pelicula de bd');
      return;
    }

    // insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
    print('agregando pelicula a bd');
  }
}
