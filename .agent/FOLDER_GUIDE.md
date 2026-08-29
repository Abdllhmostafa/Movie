# 📁 Movie App Folder & Architecture Guide

Welcome to the **Movie & Cinema App** (`movie_app`) Flutter project guide! This document outlines the project structure, architectural patterns, layer responsibilities, data flow, and step-by-step conventions for building new movie features.

---

## 🏗️ Architecture Overview

This project is built following **Clean Architecture (Feature-First approach)** paired with the **BLoC / Cubit** pattern for state management.

```
       ┌──────────────────────────────────────────────────┐
       │               PRESENTATION LAYER                 │
       │     (Screens, Movie Widgets, Cubits, States)     │
       └─────────────────────────┬────────────────────────┘
                                 │ Calls
                                 ▼
       ┌──────────────────────────────────────────────────┐
       │                  DOMAIN LAYER                    │
       │  (Business Logic, Movie Entities, UseCases, Repos)│
       └─────────────────────────▲────────────────────────┘
                                 │ Implements
                                 │ (Dependency Inversion)
       ┌─────────────────────────┴────────────────────────┐
       │                   DATA LAYER                     │
       │   (TMDB / REST Data Sources, Models, Repo Imps)  │
       └──────────────────────────────────────────────────┘
```

### Key Principles
- **Separation of Concerns:** Each layer has a distinct responsibility and is decoupled from outer dependencies.
- **Dependency Inversion:** Domain is the central core. It does not depend on Data or Presentation. Data implements interfaces defined in Domain.
- **Feature-First Organization:** Every feature (e.g., `auth`, `home`, `details`, `watchlist`) is modular and self-contained with its own Presentation, Domain, and Data layers.
- **Shared Core:** Reusable components, dark theme palette, base states, network clients, and utilities live in `lib/core/`.

---

## 📂 Root Directory Structure

```text
movie_app/
├── android/               # Android native configuration and build files
├── ios/                   # iOS native configuration and build files
├── web/                   # Web platform support
├── linux/                 # Linux desktop platform support
├── macos/                 # macOS desktop platform support
├── windows/               # Windows desktop platform support
├── lib/                   # Main Dart/Flutter source code
├── test/                  # Unit, widget, and integration tests
├── pubspec.yaml           # App dependencies, assets, fonts, and metadata
├── analysis_options.yaml  # Linting and static analysis rules
├── README.md              # Project general readme
└── .agent/                # AI Agent architecture and feature index guides
    ├── ARCHITECTURE_NOTES.md
    ├── FEATURE_INDEX.md
    └── FOLDER_GUIDE.md
```

---

## 📦 `lib/` Directory Breakdown

```text
lib/
├── core/                                # Shared global utilities
│   ├── services/                        # App-wide services (API clients, storage, network)
│   ├── states/                          # Global base states (e.g., BaseState)
│   │   └── base_state.dart
│   ├── theme/                           # Dark Cinema palette & typography
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── widgets/                         # Reusable global UI widgets
│
├── features/                            # Feature-first modules
│   └── auth/                            # Authentication Feature Module
│       ├── data/                        # Data Layer (Remote & Local data)
│       │   ├── data_source/             # API calls and DB interactions
│       │   │   ├── data_source.dart     # Abstract data source contract
│       │   │   └── data_source_imp.dart # Concrete implementation
│       │   ├── models/                  # JSON/DTO models with serialization logic
│       │   │   └── user_model.dart
│       │   └── repo/                    # Repository implementations
│       │       └── repo_imp.dart        # Implements domain repository contract
│       │
│       ├── domain/                      # Domain Layer (Pure business logic)
│       │   ├── entity/                  # Pure Dart domain entities (e.g., UserEntity)
│       │   │   └── user_entity.dart
│       │   ├── repo/                    # Abstract repository interfaces (contracts)
│       │   │   └── repo.dart
│       │   └── use_case/                # Single-responsibility business use cases
│       │       ├── login_use_case.dart
│       │       └── register_use_case.dart
│       │
│       └── presentation/                # Presentation Layer (UI & State)
│           ├── manager/                 # Cubits and UI States
│           │   ├── auth_cubit.dart
│           │   └── auth_state.dart
│           ├── screens/                 # Full screen views
│           │   ├── login_screen.dart
│           │   └── register_screen.dart
│           └── widgets/                 # Feature-specific UI widgets
│               ├── auth_button_widget.dart
│               ├── auth_header_widget.dart
│               ├── auth_prompt_row.dart
│               ├── custom_text_field.dart
│               ├── forgot_password_widget.dart
│               ├── login_form_widget.dart
│               ├── register_form_widget.dart
│               └── route_logo_widget.dart
│
└── main.dart                            # Application entry point
```

---

## 🔄 Data & Control Flow (Example: Fetching Popular Movies)

```text
[ User opens Home Screen ]
         │
         ▼
[ Presentation - HomeScreen ]
         │ Calls
         ▼
[ Presentation - HomeCubit ]
         │ Emits LoadingState
         │ Executes GetPopularMoviesUseCase
         ▼
[ Domain - GetPopularMoviesUseCase ]
         │ Calls abstract MoviesRepo.getPopularMovies()
         ▼
[ Data - MoviesRepoImp ]
         │ Calls MoviesRemoteDataSource
         ▼
[ Data - MoviesRemoteDataSourceImp ]
         │ Sends GET request to TMDB API (/movie/popular)
         ▼
[ Backend / TMDB API ]
         │ Returns JSON response
         ▼
[ Data - MovieModel.fromJson() ] (Deserializes JSON into MovieModel)
         │
         ▼
[ Data - MoviesRepoImp ] (Returns List<MovieEntity>)
         │
         ▼
[ Domain - GetPopularMoviesUseCase ]
         │ Returns Result to HomeCubit
         ▼
[ Presentation - HomeCubit ]
         │ Emits SuccessState(movies: List<MovieEntity>)
         ▼
[ Presentation - HomeScreen / MovieCarouselSlider ] (Rebuilds UI with movie posters)
```

---

## 🚀 How to Add a New Feature (e.g. `details`)

### Step 1: Domain Layer
1. **Entity**: Create `lib/features/details/domain/entity/movie_details_entity.dart`.
2. **Repository Contract**: Create `lib/features/details/domain/repo/details_repo.dart`.
3. **Use Cases**: Create `get_movie_details_use_case.dart`, `get_movie_trailers_use_case.dart`.

### Step 2: Data Layer
1. **Model**: Create `lib/features/details/data/models/movie_details_model.dart`.
2. **Data Source**:
   - `lib/features/details/data/data_source/details_data_source.dart` (Interface)
   - `lib/features/details/data/data_source/details_data_source_imp.dart` (Implementation)
3. **Repository Implementation**:
   - `lib/features/details/data/repo/details_repo_imp.dart` (Implements `DetailsRepo`).

### Step 3: Presentation Layer
1. **Manager**:
   - `details_state.dart` (Define Initial, Loading, Success, Error states).
   - `details_cubit.dart` (Calls use case and emits states).
2. **Screens & Widgets**:
   - `lib/features/details/presentation/screens/movie_details_screen.dart`
   - `lib/features/details/presentation/widgets/trailer_player_widget.dart`
   - `lib/features/details/presentation/widgets/cast_list_widget.dart`

---

## 🏷️ Naming Conventions

| Item | Naming Pattern | Example |
| :--- | :--- | :--- |
| **Files** | `snake_case.dart` | `get_movies_use_case.dart`, `movies_cubit.dart` |
| **Classes** | `PascalCase` | `GetMoviesUseCase`, `MoviesCubit`, `MovieEntity` |
| **Variables & Functions** | `camelCase` | `isFavorite`, `fetchTrending()`, `movieList` |
| **Entities** | `<Name>Entity` | `MovieEntity`, `CastEntity`, `UserEntity` |
| **Models** | `<Name>Model` | `MovieModel`, `CastModel`, `UserModel` |
| **Repositories (Domain)** | `<Name>Repo` | `MoviesRepo`, `AuthRepo` |
| **Repositories (Data)** | `<Name>RepoImp` | `MoviesRepoImp`, `AuthRepoImp` |
| **Use Cases** | `<Action><Feature>UseCase` | `GetTrendingMoviesUseCase`, `LoginUseCase` |
| **Cubits** | `<Feature>Cubit` | `MoviesCubit`, `AuthCubit` |
| **States** | `<Feature>State` | `MoviesState`, `AuthState` |
| **Screens** | `<Feature>Screen` | `HomeScreen`, `MovieDetailsScreen`, `LoginScreen` |
