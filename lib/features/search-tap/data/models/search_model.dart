import 'package:movie_app/features/search-tap/demain/entity/search_entity.dart';

class SearchModel {
  String? status;
  String? statusMessage;
  Data? data;
  Meta? meta;

  SearchModel({this.status, this.statusMessage, this.data, this.meta});

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    statusMessage = json['status_message']?.toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    meta = json['@meta'] != null ? Meta.fromJson(json['@meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['status_message'] = statusMessage;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    if (meta != null) {
      map['@meta'] = meta!.toJson();
    }
    return map;
  }
}

class Data {
  int? movieCount;
  int? limit;
  int? pageNumber;
  List<SearchMovies>? searchmovies;

  Data({this.movieCount, this.limit, this.pageNumber, this.searchmovies});

  Data.fromJson(Map<String, dynamic> json) {
    movieCount = (json['movie_count'] as num?)?.toInt();
    limit = (json['limit'] as num?)?.toInt();
    pageNumber = (json['page_number'] as num?)?.toInt();
    if (json['movies'] != null && json['movies'] is List) {
      searchmovies = <SearchMovies>[];
      for (final v in json['movies']) {
        if (v is Map<String, dynamic>) {
          searchmovies!.add(SearchMovies.fromJson(v));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['movie_count'] = movieCount;
    map['limit'] = limit;
    map['page_number'] = pageNumber;
    if (searchmovies != null) {
      map['movies'] = searchmovies!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SearchMovies {
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

  SearchMovies({
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

  SearchMovies.fromJson(Map<String, dynamic> json) {
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
    genres = (json['genres'] as List?)?.map((e) => e.toString()).toList();
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
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    map['imdb_code'] = imdbCode;
    map['title'] = title;
    map['title_english'] = titleEnglish;
    map['title_long'] = titleLong;
    map['slug'] = slug;
    map['year'] = year;
    map['rating'] = rating;
    map['runtime'] = runtime;
    map['genres'] = genres;
    map['summary'] = summary;
    map['description_full'] = descriptionFull;
    map['synopsis'] = synopsis;
    map['yt_trailer_code'] = ytTrailerCode;
    map['language'] = language;
    map['mpa_rating'] = mpaRating;
    map['background_image'] = backgroundImage;
    map['background_image_original'] = backgroundImageOriginal;
    map['small_cover_image'] = smallCoverImage;
    map['medium_cover_image'] = mediumCoverImage;
    map['large_cover_image'] = largeCoverImage;
    map['state'] = state;
    if (torrents != null) {
      map['torrents'] = torrents!.map((v) => v.toJson()).toList();
    }
    map['date_uploaded'] = dateUploaded;
    map['date_uploaded_unix'] = dateUploadedUnix;
    return map;
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
    final Map<String, dynamic> map = <String, dynamic>{};
    map['url'] = url;
    map['hash'] = hash;
    map['quality'] = quality;
    map['type'] = type;
    map['is_repack'] = isRepack;
    map['video_codec'] = videoCodec;
    map['bit_depth'] = bitDepth;
    map['audio_channels'] = audioChannels;
    map['seeds'] = seeds;
    map['peers'] = peers;
    map['size'] = size;
    map['size_bytes'] = sizeBytes;
    map['date_uploaded'] = dateUploaded;
    map['date_uploaded_unix'] = dateUploadedUnix;
    return map;
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
    final Map<String, dynamic> map = <String, dynamic>{};
    map['api_version'] = apiVersion;
    map['execution_time'] = executionTime;
    return map;
  }
}

extension MoviesExtension on SearchMovies {
  SearchEntity toEntity() {
    return SearchEntity(
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
      backgroundImage:
          backgroundImageOriginal ??
          backgroundImage ??
          largeCoverImage ??
          mediumCoverImage ??
          '',
    );
  }
}
