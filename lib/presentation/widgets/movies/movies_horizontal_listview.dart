import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia_flutter12/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/movie.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subtitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();
  // cada que se añada un listener hay que agregar un dispose
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 374,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(
              title: widget.title,
              subtitle: widget.subtitle,
            ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: ListView.builder(
            // hay que asociar el scroll controller con su listview
            controller: scrollController,
            itemCount: widget.movies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return FadeInRight(child: _Slide(movie: widget.movies[index]));
            },
          ))
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    // IMAGEN de peliculas actuales
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                movie.posterPath,
                width: 150,
                fit: BoxFit.fitWidth,
                loadingBuilder: ((context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )),
                    );
                  }
                  return GestureDetector(
                    onTap: () => context.push('/home/0/movie/${movie.id}'),
                    child: FadeInRight(child: child,));
                  
                }),
              ),
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          // Title

          SizedBox(
            width: 150,
            child: Text(movie.title, maxLines: 2, style: textStyle.titleSmall),
          ),
          // Rating
          SizedBox(
            width: 160,
            child: Row(
              children: [
                if (movie.voteAverage >= 8)
                  Icon(
                    Icons.star_rate_rounded,
                    color: Colors.yellow.shade800,
                  ),
                
                if (movie.voteAverage < 8 && movie.voteAverage > 4)
                  Icon(
                    Icons.star_half_rounded,
                    color: Colors.yellow.shade800,
                  ),
                if (movie.voteAverage <= 4)
                  Icon(
                    Icons.star_border_rounded,
                    color: Colors.yellow.shade800,
                  ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  HumanFormats.decimals(movie.voteAverage),
                  style: textStyle.bodyMedium
                      ?.copyWith(color: Colors.yellow.shade800),
                ),
                const Spacer(),
                Text(
                  HumanFormats.number(movie.popularity),
                  style: textStyle.bodyMedium,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: titleStyle,
            ),
          const Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: () {},
                child: Text(
                  subtitle!,
                  style: titleStyle,
                ))
        ],
      ),
    );
  }
}
