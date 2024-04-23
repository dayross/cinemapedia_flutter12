import 'package:go_router/go_router.dart';
import 'package:cinemapedia_flutter12/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = state.pathParameters['page'] ?? 0;
        //assert(pageIndex == 0 || pageIndex == 1 || pageIndex == 2);
        
        int indexo = int.parse(pageIndex.toString());
        return HomeScreen(pageIndex: indexo);
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
      ]),
  GoRoute(
      path: '/',
      // los guiones bajos hacen referencia a argumentos que no necesitamos
      redirect: (_, __) => '/home/0')
  // GoRoute(
  //   path: '/favourites',
  //   builder: (context, state) {
  //     return const FavouritesView();
  //   },
  // ),
]);
