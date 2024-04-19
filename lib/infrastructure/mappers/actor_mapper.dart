import 'package:cinemapedia_flutter12/domain/entities/actor.dart';
import 'package:cinemapedia_flutter12/infrastructure/models/movie_db/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null
          ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
          : 'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/no-profile-picture-icon.png',
      character: cast.character);
}
