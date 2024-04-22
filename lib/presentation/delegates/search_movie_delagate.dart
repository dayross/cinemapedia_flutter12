import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia_flutter12/config/helpers/human_formats.dart';
import 'package:cinemapedia_flutter12/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovie;
  List<Movie> initialMovies;
  // hay que especificarlo en broadcast debido a que si no se hace, se va a tomar
  // por predeterminado que solo tiene un listener.
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.searchMovie, this.initialMovies = const []});

  void clearStreams() {
    debounceMovies.close();
  }

  void _onQueryChange(String query) {
    // esta funcion es la que va a emitir el resultado de las peliculas
    // el ?? menciona que si acaso no es nulo, se checa si esta activo. si es nulo,
    // se marca false por default
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // todo BUSCAR PELICULAS y emitir stream
      // if (query.isEmpty) {
      //   debounceMovies.add([]);
      //   return;
      // }

      final movies = await searchMovie(query);
      initialMovies = movies;
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  @override
  String get searchFieldLabel => '¿Que vas a ver hoy?';
  @override
  List<Widget>? buildActions(BuildContext context) {
    // BUILD ACTIONS son para las accines que hace el boton
    return [
      StreamBuilder(
          initialData: false,
          stream: isLoadingStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return SpinPerfect(
                duration: const Duration(seconds: 10),
                spins: 10,
                infinite: true,
                animate: query.isNotEmpty,
                child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.refresh_rounded)),
              );
            }

            return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                  onPressed: () => query = '', icon: const Icon(Icons.clear)),
            );
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // BUILD LEADING para construir un icono al inicio
    // la funcion close viene del search delegate y nos ayuda a salir
    // de la pantalla de busqueda
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  Widget buildResultsSuggestions() {
    return StreamBuilder(
        initialData: initialMovies,
        stream: debounceMovies.stream,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) => _MovieItem(
                    movie: movies[index],
                    onMovieSelected: (context, movie) {
                      close(context, movie);
                      clearStreams();
                    },
                  ));
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // BUILD RESULTS que es lo que aparece cuando la persona da en enter
    return buildResultsSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // BUILD SUGGESTIONS que es lo que se hará cuando la persona este escribiendo
    _onQueryChange(query);
    return buildResultsSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // imagen
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(
                    child: child,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            //titulo
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(movie.title, style: textStyle.bodyLarge),
                  const SizedBox(
                    height: 3,
                  ),
                  (movie.overview.length > 100)
                      ? Text(
                          '${movie.overview.substring(0, 100)}...',
                        )
                      : Text(
                          movie.overview,
                        ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      Text(HumanFormats.decimals(movie.voteAverage))
                    ],
                  )
                ],
              ),
            )

            // descripcion
          ],
        ),
      ),
    );
  }
}
