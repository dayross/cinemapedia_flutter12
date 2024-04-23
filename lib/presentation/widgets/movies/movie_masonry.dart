import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/movie.dart';
import 'package:cinemapedia_flutter12/presentation/widgets/widgets.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> favMovies;
  final VoidCallback? loadNextPage;

  const MovieMasonry({super.key, required this.favMovies, this.loadNextPage});

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 100) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.favMovies.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                MoviePosterLink(movie: widget.favMovies[index])
              ],
            );
          }
          return MoviePosterLink(movie: widget.favMovies[index]);
        },
      ),
    );
  }
}
