import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String movieDBkey =
      dotenv.env['THEMOVIEDB_KEY'] ?? 'No esta configurado';

  static String movieDBtoken =
      dotenv.env['THEMOVIEDB_TOKEN'] ?? 'No esta configurado';
}
