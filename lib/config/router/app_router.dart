import 'package:go_router/go_router.dart';
import 'package:cinemapedia_flutter12/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
    routes: [
        GoRoute(
          // vamos a mnandar ese argumento de ID
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieID: movieId,);},
  ),
    ]
  ),
  
]);
