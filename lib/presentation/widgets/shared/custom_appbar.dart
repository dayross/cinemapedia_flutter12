import 'package:cinemapedia_flutter12/domain/entities/movie.dart';
import 'package:cinemapedia_flutter12/presentation/delegates/search_movie_delagate.dart';
import 'package:cinemapedia_flutter12/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Icon(
              Icons.movie_creation_outlined,
              color: colors.primary,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'MovieMagz',
              style: titleStyle,
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  final searchedMovies = ref.read(searchedMoviesProvider);
                  // tomamos el provider que va a guardar nuestra busqueda
                  final searchQuery = ref.read(searchQueryProvider);
                  showSearch<Movie?>(
                    // le decimos que el query es igual al contenido del provider
                      query: searchQuery,
                      context: context,
                      delegate: SearchMovieDelegate(
                        initialMovies: searchedMovies,
                        searchMovie: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery)
                      /* delegate: SearchMovieDelegate(searchMovie: (query){
                        //leemos el provider y le notificamos de cambios
                        ref
                            .read(searchQueryProvider.notifier)
                            // actualizamos el provider con el nuevo valor de la busqueda
                            .update((state) => query);
                            // devolvemos la funcion con la busqueda de peliculas
                        return movieRepository.searchMovies(query); */
                      ).then((movie) {
                    if (movie == null) return;
                    context.push('/movie/${movie.id}');
                  });
                },
                icon: const Icon(Icons.search))
          ],
        ),
      ),
    ));
  }
}
