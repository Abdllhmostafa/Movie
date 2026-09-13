import 'package:movie_app/features/layout/demain/entitiy/cast_entity.dart';

class MovieDetailsExtraEntity {
  final List<String> screenshots;
  final List<CastEntity> cast;
  final List<String> genres;

  const MovieDetailsExtraEntity({
    this.screenshots = const [],
    this.cast = const [],
    this.genres = const [],
  });
}
