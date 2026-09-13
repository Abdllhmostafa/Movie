class MovieEntity {
  final int id;
  final String image;
  final String title;
  final double rating;
  final int year;
  final int runtime;
  final String summary;
  final List<String> genres;
  final String backgroundImage;

  MovieEntity({
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
}
