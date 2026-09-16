import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';

class SearchEntity {
  final int id;
  final String image;
  final String title;
  final double rating;
  final int year;
  final int runtime;
  final String summary;
  final List<String> genres;
  final String backgroundImage;

  SearchEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.rating,
    this.year = 0,
    this.runtime = 0,
    this.summary = '',
    this.genres = const [],
    this.backgroundImage = '',
  });

  MovieEntity toMovieEntity() {
    return MovieEntity(
      id: id,
      title: title,
      image: image,
      rating: rating,
      year: year,
      runtime: runtime,
      summary: summary,
      genres: genres,
      backgroundImage: backgroundImage,
    );
  }
}
