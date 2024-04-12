import 'package:cinemapedia_flutter12/presentation/widgets/shared/custom_bottom_navigation_bar.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    
    final spotlightMovie =
        ref.watch(movieSlideshowProvider);
    return Column(
      children: [
        const CustomAppBar(),
        const SizedBox(
          height: 15,
        ),
        MoviesSlideShow(movies: spotlightMovie),
        
      ],
    );
  }
}
