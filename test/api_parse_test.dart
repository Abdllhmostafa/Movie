import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/layout/data/models/movie_model.dart';
import 'package:movie_app/features/layout/demain/entitiy/cast_entity.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_details_extra_entity.dart';

void main() {
  test('MovieModel parses int ratings (0) and null lists safely', () {
    final rawJson = {
      "status": "ok",
      "status_message": "Query was successful",
      "data": {
        "movie_count": 2,
        "limit": 20,
        "page_number": 1,
        "movies": [
          {
            "id": 1,
            "title": "Movie with integer rating",
            "rating": 0,
            "genres": ["Action", "Comedy"],
            "medium_cover_image": "https://example.com/img1.jpg",
          },
          {
            "id": 2,
            "title": "Movie with double rating",
            "rating": 7.8,
            "genres": null,
            "medium_cover_image": "https://example.com/img2.jpg",
          },
        ],
      },
    };

    final model = MovieModel.fromJson(rawJson);
    expect(model.status, 'ok');
    final movies = model.data?.movies;
    expect(movies?.length, 2);

    final entities = movies!.map((m) => m.toEntity()).toList();
    expect(entities[0].rating, 0.0);
    expect(entities[1].rating, 7.8);
    expect(entities[0].title, "Movie with integer rating");
  });

  test('CastEntity and MovieDetailsExtraEntity instantiate correctly', () {
    const cast = CastEntity(
      name: 'Leonardo DiCaprio',
      character: 'Cobb',
      image: 'https://example.com/cobb.jpg',
    );
    expect(cast.name, 'Leonardo DiCaprio');
    expect(cast.character, 'Cobb');
    expect(cast.image, 'https://example.com/cobb.jpg');

    const extra = MovieDetailsExtraEntity(
      screenshots: ['https://example.com/s1.jpg'],
      cast: [cast],
      genres: ['Sci-Fi', 'Action'],
    );
    expect(extra.screenshots.length, 1);
    expect(extra.cast.length, 1);
    expect(extra.cast.first.name, 'Leonardo DiCaprio');
    expect(extra.genres, ['Sci-Fi', 'Action']);
  });
}
