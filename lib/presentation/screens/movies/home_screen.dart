import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia_flutter12/presentation/providers/providers.dart';
import 'package:cinemapedia_flutter12/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    //final movies =
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final spotlightMovie = ref.watch(movieSlideshowProvider);
    final popularMovie = ref.watch(popularMoviesProvider);
    final upcomingMovie = ref.watch(upcomingMoviesProvider);
    final topRatedMovie = ref.watch(topRatedMoviesProvider);
    
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          title: CustomAppBar(),
          
          flexibleSpace: FlexibleSpaceBar(),
        ),

        // el delegate es la funcion ue nos permite hacer los
        // widgets dentro de un list view
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              MoviesSlideShow(movies: spotlightMovie),

              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: 'Actualmente',
                subtitle: 'Viernes 12',
                loadNextPage: () {
                  // dentro de funciones, se usa el read
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                },
              ),
              MovieHorizontalListview(
                movies: upcomingMovie,
                title: 'Proximamente',
                subtitle: 'En este mes',
                loadNextPage: () =>  ref.watch(upcomingMoviesProvider.notifier).loadNextPage()
              ),
              MovieHorizontalListview(
                movies: popularMovie,
                title: 'Populares',
                subtitle: 'De siempre',
                loadNextPage: () {
                  // dentro de funciones, se usa el read
                  ref.read(popularMoviesProvider.notifier).loadNextPage();
                },
              ),
              MovieHorizontalListview(
                movies: topRatedMovie,
                title: 'Mejor calificadas',
                subtitle: 'Hoy',
                loadNextPage: () {
                  // dentro de funciones, se usa el read
                  ref.read(topRatedMoviesProvider.notifier).loadNextPage;
                },
              ),
              const SizedBox(
                height: 15,
              )
            ],
          );
        }, childCount: 1))
      ],
    );
  }
}
