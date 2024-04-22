import 'package:go_router/go_router.dart';

import 'package:cinemapedia_flutter12/presentation/views/views.dart';
import 'package:cinemapedia_flutter12/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomeView();
          },
          routes: [
            GoRoute(
              // vamos a mnandar ese argumento de ID
              path: 'movie/:id',
              name: MovieScreen.name,
              builder: (context, state) {
                final movieId = state.pathParameters['id'] ?? 'no-id';
                return MovieScreen(
                  movieID: movieId,
                );
              },
            ),
          ],
        ),
        GoRoute(
            path: '/favourites',
            builder: (context, state) {
              return const FavouritesView();
            }),
      ])

  // // rutas padre / hijo
  // GoRoute(
  //   path: '/',
  //   name: HomeScreen.name,
  //   builder: (context, state) => const HomeScreen(childView: HomeView()),
  //   routes: [
  //       GoRoute(
  //         // vamos a mnandar ese argumento de ID
  //         path: 'movie/:id',
  //         name: MovieScreen.name,
  //         builder: (context, state) {
  //           final movieId = state.pathParameters['id'] ?? 'no-id';
  //           return MovieScreen(movieID: movieId,);},
  // ),
  //   ]
  // ),
]);
