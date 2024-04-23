import 'package:cinemapedia_flutter12/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia_flutter12/presentation/providers/providers.dart';

import '../../../domain/entities/movie.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieID; // ID de pelicula

  const MovieScreen({super.key, required this.movieID});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // cuando estamos adentro de init states o de metodos, usamos el read
    // aqui hacemos la llamada http
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieID);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieID);
  }

  @override
  Widget build(BuildContext context) {
    // una variable de tipo Movie que checa el provider y del mapa de
    // peliculas obtenemos el ID de peliculas
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieID];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
        body: CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        _CustomSliverAppBar(
          movie: movie,
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) => _MovieDetails(movie: movie),
          childCount: 1,
        ))
      ],
    ));
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // imagen de poster de pelicula
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              // espacio entre imagen de pelicula y descripcion
              const SizedBox(
                width: 20,
              ),
              // descripcion de pelicula
              SizedBox(
                width: (size.width - 40) * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleLarge,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(movie.overview,
                        style: textStyle.bodyMedium,
                        textAlign: TextAlign.justify)
                  ],
                ),
              ),
            ],
          ),
        ),
        /** generos de la pelicula */
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((genre) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(
                      genre,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  )))
            ],
          ),
        ),
        // TODO MOSTRAR ACTORES EN LISTVIEW
        _ActorsByMovie(
          movieId: movie.id.toString(),
        ),

        const SizedBox(
          height: 100,
        )
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final textStyle = Theme.of(context).textTheme;
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(
        strokeWidth: 2,
      );
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (actors.length > 10) ? 10 : actors.length,
          itemBuilder: (context, index) {
            final actor = actors[index];
            return Container(
              padding: const EdgeInsets.all(8),
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto del actor
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Nombre del actor
                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    actor.name,
                    maxLines: 2,
                    style: textStyle.bodyMedium,
                  ),
                  // Rol

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: textStyle.bodySmall,
                  ),
                ],
              ),
            );
          }),
    );
  }
}

// el future provider es para tareas asincronas
final isFavProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  // llamamos al provider de la base de datos
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  // si la pelicula esta en la Bd, entonces esta en favoritos
  print('buscando pelicula en BD');
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final AsyncValue isFavFuture = ref.watch(isFavProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: const Color.fromARGB(255, 251, 251, 251),
      actions: [
        IconButton(
            onPressed: () async{
              //ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
              await ref.read(favouriteMoviesProvider.notifier).toggleFavorite(movie);
              print('presionaste boton');

              ref.invalidate(isFavProvider(movie.id));
              print('Invalidando provider');
            },
            icon: isFavFuture.when(
                data: (isFav) => isFav
                    ? const Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border_rounded,
                        color: Color(0xFFF5F5F5),
                      ),
                error: (_, __) {
                  return const SnackBar(
                    content: Text('Sucedió un error'),
                  );
                },
                loading: () => const CircularProgressIndicator(
                      strokeWidth: 2,
                    ))),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const SizedBox();
                  }
                  return FadeIn(child: child);
                },
              ),
            ),
            //gradiente del boton

            const _CustomGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.0, 0.2],
                color: [Colors.black54, Colors.transparent]),

            const _CustomGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.8, 1.0],
                color: [Colors.transparent, Colors.black87])
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final List<Color> color;

  const _CustomGradient(
      {required this.begin,
      required this.end,
      required this.stops,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: this.begin,
                  end: this.end,
                  stops: this.stops,
                  colors: this.color))),
    );
  }
}
