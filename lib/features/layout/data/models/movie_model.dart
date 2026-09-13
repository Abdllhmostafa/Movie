import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';

class MovieModel {
  String? status;
  String? statusMessage;
  Data? data;
  Meta? meta;
  List<Movies>? movies;

  MovieModel({this.status, this.statusMessage, this.data, this.meta});

  MovieModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    statusMessage = json['status_message']?.toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    meta = json['@meta'] != null ? Meta.fromJson(json['@meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['status'] = status;
    result['status_message'] = statusMessage;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    if (meta != null) {
      result['@meta'] = meta!.toJson();
    }
    return result;
  }
}

class Data {
  int? movieCount;
  int? limit;
  int? pageNumber;
  List<Movies>? movies;

  Data({this.movieCount, this.limit, this.pageNumber, this.movies});

  Data.fromJson(Map<String, dynamic> json) {
    movieCount = (json['movie_count'] as num?)?.toInt();
    limit = (json['limit'] as num?)?.toInt();
    pageNumber = (json['page_number'] as num?)?.toInt();
    if (json['movies'] != null && json['movies'] is List) {
      movies = <Movies>[];
      for (final v in json['movies']) {
        if (v is Map<String, dynamic>) {
          movies!.add(Movies.fromJson(v));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['movie_count'] = movieCount;
    result['limit'] = limit;
    result['page_number'] = pageNumber;
    if (movies != null) {
      result['movies'] = movies!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class Movies {
  int? id;
  String? url;
  String? imdbCode;
  String? title;
  String? titleEnglish;
  String? titleLong;
  String? slug;
  int? year;
  double? rating;
  int? runtime;
  List<String>? genres;
  String? summary;
  String? descriptionFull;
  String? synopsis;
  String? ytTrailerCode;
  String? language;
  String? mpaRating;
  String? backgroundImage;
  String? backgroundImageOriginal;
  String? smallCoverImage;
  String? mediumCoverImage;
  String? largeCoverImage;
  String? state;
  List<Torrents>? torrents;
  String? dateUploaded;
  int? dateUploadedUnix;

  Movies({
    this.id,
    this.url,
    this.imdbCode,
    this.title,
    this.titleEnglish,
    this.titleLong,
    this.slug,
    this.year,
    this.rating,
    this.runtime,
    this.genres,
    this.summary,
    this.descriptionFull,
    this.synopsis,
    this.ytTrailerCode,
    this.language,
    this.mpaRating,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.state,
    this.torrents,
    this.dateUploaded,
    this.dateUploadedUnix,
  });

  Movies.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    url = json['url']?.toString();
    imdbCode = json['imdb_code']?.toString();
    title = json['title']?.toString();
    titleEnglish = json['title_english']?.toString();
    titleLong = json['title_long']?.toString();
    slug = json['slug']?.toString();
    year = (json['year'] as num?)?.toInt();
    rating = (json['rating'] as num?)?.toDouble();
    runtime = (json['runtime'] as num?)?.toInt();
    if (json['genres'] != null && json['genres'] is List) {
      genres = (json['genres'] as List).map((e) => e.toString()).toList();
    }
    summary = json['summary']?.toString();
    descriptionFull = json['description_full']?.toString();
    synopsis = json['synopsis']?.toString();
    ytTrailerCode = json['yt_trailer_code']?.toString();
    language = json['language']?.toString();
    mpaRating = json['mpa_rating']?.toString();
    backgroundImage = json['background_image']?.toString();
    backgroundImageOriginal = json['background_image_original']?.toString();
    smallCoverImage = json['small_cover_image']?.toString();
    mediumCoverImage = json['medium_cover_image']?.toString();
    largeCoverImage = json['large_cover_image']?.toString();
    state = json['state']?.toString();
    if (json['torrents'] != null && json['torrents'] is List) {
      torrents = <Torrents>[];
      for (final v in json['torrents']) {
        if (v is Map<String, dynamic>) {
          torrents!.add(Torrents.fromJson(v));
        }
      }
    }
    dateUploaded = json['date_uploaded']?.toString();
    dateUploadedUnix = (json['date_uploaded_unix'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['url'] = url;
    result['imdb_code'] = imdbCode;
    result['title'] = title;
    result['title_english'] = titleEnglish;
    result['title_long'] = titleLong;
    result['slug'] = slug;
    result['year'] = year;
    result['rating'] = rating;
    result['runtime'] = runtime;
    result['genres'] = genres;
    result['summary'] = summary;
    result['description_full'] = descriptionFull;
    result['synopsis'] = synopsis;
    result['yt_trailer_code'] = ytTrailerCode;
    result['language'] = language;
    result['mpa_rating'] = mpaRating;
    result['background_image'] = backgroundImage;
    result['background_image_original'] = backgroundImageOriginal;
    result['small_cover_image'] = smallCoverImage;
    result['medium_cover_image'] = mediumCoverImage;
    result['large_cover_image'] = largeCoverImage;
    result['state'] = state;
    if (torrents != null) {
      result['torrents'] = torrents!.map((v) => v.toJson()).toList();
    }
    result['date_uploaded'] = dateUploaded;
    result['date_uploaded_unix'] = dateUploadedUnix;
    return result;
  }
}

class Torrents {
  String? url;
  String? hash;
  String? quality;
  String? type;
  String? isRepack;
  String? videoCodec;
  String? bitDepth;
  String? audioChannels;
  int? seeds;
  int? peers;
  String? size;
  int? sizeBytes;
  String? dateUploaded;
  int? dateUploadedUnix;

  Torrents({
    this.url,
    this.hash,
    this.quality,
    this.type,
    this.isRepack,
    this.videoCodec,
    this.bitDepth,
    this.audioChannels,
    this.seeds,
    this.peers,
    this.size,
    this.sizeBytes,
    this.dateUploaded,
    this.dateUploadedUnix,
  });

  Torrents.fromJson(Map<String, dynamic> json) {
    url = json['url']?.toString();
    hash = json['hash']?.toString();
    quality = json['quality']?.toString();
    type = json['type']?.toString();
    isRepack = json['is_repack']?.toString();
    videoCodec = json['video_codec']?.toString();
    bitDepth = json['bit_depth']?.toString();
    audioChannels = json['audio_channels']?.toString();
    seeds = (json['seeds'] as num?)?.toInt();
    peers = (json['peers'] as num?)?.toInt();
    size = json['size']?.toString();
    sizeBytes = (json['size_bytes'] as num?)?.toInt();
    dateUploaded = json['date_uploaded']?.toString();
    dateUploadedUnix = (json['date_uploaded_unix'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['url'] = url;
    result['hash'] = hash;
    result['quality'] = quality;
    result['type'] = type;
    result['is_repack'] = isRepack;
    result['video_codec'] = videoCodec;
    result['bit_depth'] = bitDepth;
    result['audio_channels'] = audioChannels;
    result['seeds'] = seeds;
    result['peers'] = peers;
    result['size'] = size;
    result['size_bytes'] = sizeBytes;
    result['date_uploaded'] = dateUploaded;
    result['date_uploaded_unix'] = dateUploadedUnix;
    return result;
  }
}

class Meta {
  int? apiVersion;
  String? executionTime;

  Meta({this.apiVersion, this.executionTime});

  Meta.fromJson(Map<String, dynamic> json) {
    apiVersion = (json['api_version'] as num?)?.toInt();
    executionTime = json['execution_time']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['api_version'] = apiVersion;
    result['execution_time'] = executionTime;
    return result;
  }
}

extension MoviesExtension on Movies {
  MovieEntity toEntity() {
    return MovieEntity(
      id: id ?? 0,
      title: title ?? '',
      image: mediumCoverImage ?? largeCoverImage ?? smallCoverImage ?? '',
      rating: rating ?? 0.0,
      year: year ?? 0,
      runtime: runtime ?? 0,
      summary: (summary != null && summary!.isNotEmpty)
          ? summary!
          : (descriptionFull ?? synopsis ?? ''),
      genres: genres ?? const [],
      backgroundImage: backgroundImageOriginal ??
          backgroundImage ??
          largeCoverImage ??
          mediumCoverImage ??
          '',
    );
  }
}