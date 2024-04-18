import 'package:cinemapedia_flutter12/presentation/providers/movies/movie_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        Padding(padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            // imagen de poster de pelicula
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(movie.posterPath,
              width: size.width * 0.3,
              ),),
               // espacio entre imagen de pelicula y descripcion
              const SizedBox(width: 20,),
              // descripcion de pelicula
              SizedBox(
                width: (size.width -40)*0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(movie.title, style: textStyle.titleLarge,),
                  SizedBox(height: 15,),
                  Text(movie.overview, style: textStyle.bodyMedium, textAlign: TextAlign.justify)
                ],),
              ),
          ],),),
          /** generos de la pelicula */
          Padding(padding: EdgeInsets.all(8),
          child: Wrap(children: [
            ...movie.genreIds.map((genre) => Container(
              margin: const EdgeInsets.only(right: 10),
              child: Chip(
                label: Text(genre, style: TextStyle(color: Colors.white),),
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),)))
          ],),),


         const SizedBox(height: 100,)
      ],
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: const Color.fromARGB(255, 251, 251, 251),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                    Colors.black12,
                    Colors.transparent,
                    Colors.black87
                  ]))),
            )
          ],
        ),
      ),
    );
  }
}
