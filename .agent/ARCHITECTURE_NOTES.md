# 🎬 Movie App Architecture Notes & Design Decisions

This document contains in-depth architectural notes, design decisions, principles, and guidelines adopted in the **Flutter Movie & Cinema Application** (`movie_app`).

---

## 🎯 1. Architectural Philosophy

The architecture of this project is based on **Clean Architecture (Uncle Bob)** combined with a **Feature-First (Vertical Slice)** organization and the **BLoC / Cubit** state management pattern.

### Core Objectives
1. **Testability:** Movie business logic, trailer fetchers, search queries, and watchlist use cases can be unit-tested in isolation without launching a Flutter UI test or running an emulator.
2. **Maintainability:** Code is modularized by movie feature. Changes to one feature (e.g. `movies_details` or `watchlist`) do not break unrelated features (e.g. `auth` or `search`).
3. **Framework Independence:** The core business rules (Domain layer) are written in pure Dart and do not depend on Flutter, UI frameworks, or third-party libraries (e.g. Dio, TMDB SDK, SharedPreferences).
4. **Scalability:** New movie features (e.g. Cast Filmography, Video Streaming, Offline Download) can be developed in parallel following standard layer conventions.

---

## 📐 2. The Dependency Rule

The fundamental rule of Clean Architecture is: **Dependencies can only point inward**.

```
    ┌─────────────────────────────────────────────────────────────┐
    │                    PRESENTATION LAYER                       │
    │         (Flutter UI, Movie Cards, Sliders, Cubits)          │
    │                              │                              │
    │                              ▼ depends on                   │
    │               ┌─────────────────────────────┐               │
    │               │        DOMAIN LAYER         │               │
    │               │  (Movie Entities, UseCases, │               │
    │               │   Repository Contracts)     │               │
    │               └─────────────────────────────┘               │
    │                              ▲ implemented by               │
    │                              │                              │
    │                      DATA LAYER                             │
    │    (TMDB / REST API Sources, Movie DTOs, Repo Implementations)│
    └─────────────────────────────────────────────────────────────┘
```

- **Domain Layer is completely independent:** Contains pure movie enterprise logic (e.g., `MovieEntity`, `MovieDetailsEntity`, `WatchlistEntity`).
- **Data Layer depends on Domain Layer:** Implements repository interfaces, deserializes TMDB / backend JSON into Domain entities, and manages local caching (e.g., Hive / SharedPreferences).
- **Presentation Layer depends on Domain Layer:** Executes Use Cases (e.g. `GetPopularMoviesUseCase`, `SearchMoviesUseCase`) through Cubits and renders cinematic UI widgets.

---

## 🔬 3. In-Depth Layer Breakdown & Notes

### 🟢 A. Domain Layer (`lib/features/<feature>/domain/`)
The central layer containing pure movie business entities, contracts, and interactors.

#### 1. Entities (`domain/entity/`)
- **What they are:** Plain Dart objects representing core domain models (e.g., `MovieEntity`, `MovieDetailsEntity`, `CastEntity`, `GenreEntity`, `TrailerEntity`, `UserEntity`).
- **Rules:**
  - **No** `fromJson` / `toJson` methods inside Entities (leave serialization to Data Models).
  - Use `final` immutable fields and const constructors.
  - Value equality (e.g., `Equatable` or custom `operator ==`).

#### 2. Repository Contracts (`domain/repo/`)
- **What they are:** Abstract interfaces defining *what* movie data operations exist, without specifying *how* they are executed.
- **Example:**
  ```dart
  abstract class MoviesRepo {
    Future<Either<Failure, List<MovieEntity>>> getTrendingMovies();
    Future<Either<Failure, MovieDetailsEntity>> getMovieDetails(int movieId);
    Future<Either<Failure, List<MovieEntity>>> searchMovies(String query);
  }
  ```

#### 3. Use Cases / Interactors (`domain/use_case/`)
- **What they are:** Classes encapsulating a **single, specific movie action**.
- **Rules:**
  - Each usecase has a single responsibility and uses the `call()` method.
  - Examples: `GetTrendingMoviesUseCase`, `GetMovieDetailsUseCase`, `ToggleWatchlistUseCase`, `SearchMoviesUseCase`.

---

### 🔵 B. Data Layer (`lib/features/<feature>/data/`)
Responsible for remote movie API calls (e.g., TMDB / Backend) and local cache persistence.

#### 1. Models / DTOs (`data/models/`)
- **What they are:** Data Transfer Objects extending or mapping to Domain Entities.
- **Responsibilities:**
  - Deserialization (`fromJson`) and Serialization (`toJson`).
  - Mapping TMDB poster/backdrop paths to full image URLs.
    ```dart
    class MovieModel extends MovieEntity {
      const MovieModel({
        required super.id,
        required super.title,
        required super.overview,
        required super.posterPath,
        required super.backdropPath,
        required super.voteAverage,
        required super.releaseDate,
      });

      factory MovieModel.fromJson(Map<String, dynamic> json) {
        return MovieModel(
          id: json['id'] as int,
          title: json['title'] as String? ?? '',
          overview: json['overview'] as String? ?? '',
          posterPath: json['poster_path'] != null 
              ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}' 
              : null,
          backdropPath: json['backdrop_path'] != null 
              ? 'https://image.tmdb.org/t/p/original${json['backdrop_path']}' 
              : null,
          voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
          releaseDate: json['release_date'] as String? ?? '',
        );
      }
    }
    ```

#### 2. Data Sources (`data/data_source/`)
- **Remote Data Source:** Directly interacts with Movie REST APIs (TMDB endpoints: `/trending/movie/day`, `/movie/{id}`, `/search/movie`).
- **Local Data Source:** Caches watchlist, recent searches, and offline movie metadata.

#### 3. Repository Implementations (`data/repo/`)
- **Responsibilities:**
  - Coordinates between Remote & Local data sources.
  - Catches exceptions and returns domain `Failure` / Result objects.
  - Maps `MovieModel` lists into `MovieEntity` lists.

---

### 🟠 C. Presentation Layer (`lib/features/<feature>/presentation/`)
Responsible for cinematic UI rendering, animations, user interactions, and state management.

#### 1. State Management with Cubit (`presentation/manager/`)
- **State Modeling:**
  - Immutable states representing UI phases (Initial, Loading, Success, Error).
  - Sealed classes / `BaseState` wrapper for exhaustive handling:
    ```dart
    sealed class MoviesState {}
    class MoviesInitialState extends MoviesState {}
    class MoviesLoadingState extends MoviesState {}
    class MoviesSuccessState extends MoviesState {
      final List<MovieEntity> movies;
      const MoviesSuccessState(this.movies);
    }
    class MoviesErrorState extends MoviesState {
      final String message;
      const MoviesErrorState(this.message);
    }
    ```

#### 2. Separation of Widgets (`presentation/screens/` vs `presentation/widgets/`)
- **Screens (Container / Smart Widgets):**
  - High-level views (`HomeScreen`, `MovieDetailsScreen`, `SearchScreen`, `WatchlistScreen`, `LoginScreen`).
  - Manage `BlocConsumer` / `BlocProvider`, scaffold, and navigation transitions.
- **Widgets (Presentational / Dumb Widgets):**
  - Modular, reusable sub-components (`MovieCardWidget`, `MovieSliderWidget`, `RatingBadgeWidget`, `GenreChipWidget`, `CustomTextField`, `AuthButtonWidget`).
  - Receive data via constructor parameters and dispatch user interactions via callbacks.

---

### 🟣 D. Core Layer (`lib/core/`)
Universal cross-cutting utilities used across the entire Movie App:

- `core/services/`: API client (`DioFactory`, TMDB interceptors, API key handlers), local cache service.
- `core/states/`: Generic state definitions (`BaseState`, `LoadingState`, `SuccessState`, `ErrorState`).
- `core/theme/`: Dark Cinema palette (`AppColors`), typography, dark theme configuration (`AppTheme`).
- `core/widgets/`: Universal components (`MoviePoster`, `ShimmerLoader`, `RatingStar`, `CustomButton`, `CustomTextField`).

---

## 🎨 4. Dark Cinema Design Guidelines

- **Primary Color:** Cinema Gold (`#FFBB3B`) - Used for active ratings, CTA buttons, highlighted tabs, focus borders.
- **Background Color:** Deep Obsidian (`#121312`) - Cinematic dark backdrop.
- **Surface Color:** Slate / Charcoal (`#282A28`, `#1E1E1E`) - Movie cards, text fields, bottom navigation bar.
- **Text Hierarchy:**
  - Titles: White (`#FFFFFF`), Bold / ExtraBold, clear letter-spacing.
  - Body & Subtitles: Slate Grey (`#CBCBCB`, `#707070`) for readability.
- **Visual Elements:** High-resolution poster backdrops with vertical gradient scrims (`LinearGradient` from transparent to `#121312`).

---

## ⚡ 5. Error & Network Handling

```
[ Movie API throws DioException / SocketException ]
                     │
                     ▼
[ Repository catches Exception and maps to Failure ]
                     │ (e.g. ServerFailure, NetworkFailure)
                     ▼
[ UseCase returns Failure / Result ]
                     │
                     ▼
[ Cubit emits ErrorState(errorMessage) ]
                     │
                     ▼
[ UI displays Error Banner / Retry Button ]
```

---

## 🚫 6. Architecture Guardrails

| ✅ DO | ❌ DON'T |
| :--- | :--- |
| **Keep Domain pure Dart** without importing `package:flutter/...`. | **Never** import UI packages or Flutter widgets inside `domain/`. |
| **Emit immutable states** from Cubits. | **Never** mutate state lists/objects in-place without `emit()`. |
| **Map API Models to Entities** in the Data layer before returning to Domain. | **Never** expose raw API JSON maps or TMDB response keys to UI widgets. |
| **Use `BlocListener`** for side effects (toasts, navigation, snackbars). | **Never** trigger `Navigator.push` directly inside Cubit functions. |
| **Keep Use Cases single-purpose** with `call()` method. | **Never** combine unrelated operations into one monolithic Use Case. |
