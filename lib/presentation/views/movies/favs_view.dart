import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia_flutter12/presentation/providers/providers.dart';
import 'package:cinemapedia_flutter12/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritesView extends ConsumerStatefulWidget {
  const FavouritesView({super.key});

  @override
  FavouritesViewState createState() => FavouritesViewState();
}

class FavouritesViewState extends ConsumerState<FavouritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favouriteMoviesProvider.notifier).loadNextPage();

    isLoading = false;
    if (movies.isEmpty) isLastPage = true;
  }

  @override
  Widget build(BuildContext context) {
    // esto me da un mapa de las peliculas
    // un mapa es cmo un diccionario de python. tiene una llave y un valor.
    // aqui accedemos a sus valores y los pasamos a una lista para pder iterarla
    final movies = ref.watch(favouriteMoviesProvider).values.toList();
    return Scaffold(
        body: FadeIn(
          child: MovieMasonry(
                favMovies: movies,
              ),
        ));
  }
}
