# 📜 Development Rules & Coding Standards — Movie App

This document establishes the mandatory **development rules, architectural guardrails, coding conventions, and quality standards** for all developers and AI agents working on the **Route Movie App** (`movie_app`).

---

## 🏛️ 1. Clean Architecture Guardrails

### Rule 1.1 — The Inward Dependency Rule
- **Dependencies must only point inward**:
  $$\text{Presentation} \longrightarrow \text{Domain} \longleftarrow \text{Data}$$
- **Domain layer is 100% pure Dart**: It must **NEVER** import:
  - `package:flutter/...` (widgets, material, cupertino)
  - `package:dio/...` or any HTTP networking package
  - `package:shared_preferences/...`, `package:hive/...`, or local database packages
  - Any file from `lib/features/<feature>/data/` or `lib/features/<feature>/presentation/`
- **Data layer depends on Domain**: Implements domain repository interfaces and converts data models into domain entities.
- **Presentation layer depends on Domain**: Calls Use Cases via Cubits/Blocs and receives immutable domain entities.

### Rule 1.2 — Feature-First Organization
- Every business module must be placed in `lib/features/<feature_name>/` containing:
  - `domain/`: `entity/`, `repo/`, `use_case/`
  - `data/`: `data_source/`, `models/`, `repo/`
  - `presentation/`: `manager/` (cubit/state), `screens/`, `widgets/`
- Cross-cutting, shared code used across multiple features lives strictly in `lib/core/`.

---

## 🧩 2. Domain Layer Rules

### Rule 2.1 — Pure Immutable Entities
- Entities represent the core business models (e.g., `MovieEntity`, `CastEntity`, `UserEntity`).
- **All fields must be `final`**.
- Constructors must be `const`.
- Entities must **NOT** contain `fromJson()` or `toJson()` methods. Serialization belongs exclusively in the Data layer (`Models`).

### Rule 2.2 — Single-Responsibility Use Cases
- Each use case must represent a **single business action** (e.g., `GetTrendingMoviesUseCase`, `SearchMoviesUseCase`).
- Use cases must implement a callable method `call()` for clean invocation:
  ```dart
  class GetPopularMoviesUseCase {
    final MoviesRepo repo;
    const GetPopularMoviesUseCase(this.repo);

    Future<Either<Failure, List<MovieEntity>>> call() {
      return repo.getPopularMovies();
    }
  }
  ```
- Do **NOT** combine unrelated operations (e.g. `LoginAndFetchProfileAndSaveTokenUseCase`) into a single use case.

### Rule 2.3 — Repository Contracts
- Repository interfaces in `domain/repo/` must define abstract contracts returning domain entities or functional result types (`Either<Failure, T>` / `Result<T>`).
- Never return raw HTTP responses or data DTOs from domain repository contracts.

---

## 💾 3. Data Layer Rules

### Rule 3.1 — Models / DTOs
- Models must extend or map to their corresponding Domain Entities:
  ```dart
  class MovieModel extends MovieEntity {
    const MovieModel({required super.id, required super.title, ...});
    factory MovieModel.fromJson(Map<String, dynamic> json) => ...;
    Map<String, dynamic> toJson() => ...;
  }
  ```
- Keep all JSON keys, null-coalescing defaults, and image URL formatting inside `Model.fromJson()`.

### Rule 3.2 — Data Sources
- Always separate interface from implementation:
  - `movies_data_source.dart` (abstract class contract)
  - `movies_data_source_imp.dart` (concrete HTTP / DB client)
- Handle low-level exceptions (e.g., `DioException`, `SocketException`, `FormatException`) inside the data source or repository implementation.

### Rule 3.3 — Repository Implementations
- `*_repo_imp.dart` must implement the domain interface `*_repo.dart`.
- Coordinate between remote APIs and local cache.
- Catch raw exceptions and convert them into domain `Failure` objects (e.g., `ServerFailure`, `NetworkFailure`, `CacheFailure`).

---

## 🎨 4. Presentation & State Management Rules

### Rule 4.1 — Cubit & State Conventions
- State classes must be **immutable**.
- Use `copyWith()` to emit new states. **Never mutate existing state objects directly**.
- States must clearly reflect the UI lifecycle:
  - `InitialState`
  - `LoadingState`
  - `SuccessState<T>`
  - `ErrorState`
- Use Dart 3 `sealed class` or the generic `BaseState<T>` pattern.

### Rule 4.2 — Separation of Screens vs Widgets
- **Screens (`presentation/screens/`)**:
  - High-level containers that house `Scaffold`, `BlocConsumer` / `BlocListener` / `BlocProvider`.
  - Handle side-effects (navigation, dialogs, snackbars, keyboard unfocus).
  - Orchestrate layout by assembling modular child widgets.
- **Widgets (`presentation/widgets/`)**:
  - Presentational, reusable components (e.g. `MovieCardWidget`, `CustomTextField`, `AuthButtonWidget`).
  - Receive data via constructor parameters.
  - Trigger user actions via `VoidCallback` or parameterized callbacks.
  - Must **NOT** directly execute repository calls or API requests.

### Rule 4.3 — Side-Effect Separation
- Never perform UI navigation (`Navigator.push`, `context.go`) directly inside Cubits.
- Trigger side-effects exclusively from `BlocListener` or `BlocConsumer.listener` in the UI layer.

---

## 🎭 5. Design System & Theme Rules

### Rule 5.1 — Dark Cinema Palette Mandatory
- Never hardcode color hex values in screen or widget files.
- Always reference tokens from `AppColors`:
  - Backgrounds: `AppColors.background` (`#121312`)
  - Primary Accents & CTAs: `AppColors.primary` / `AppColors.gold` (`#FFBB3B`)
  - Elevated Cards & Surfaces: `AppColors.cardBackground` (`#1E1E1E`), `AppColors.surface` (`#282A28`)
  - Text: `AppColors.textWhite` (`#FFFFFF`), `AppColors.textGrey` (`#CBCBCB`)
  - Borders: `AppColors.inputBorder` (`#383B38`)
  - Errors: `AppColors.error` (`#E53935`)

### Rule 5.2 — Responsive & Keyboard Handling
- Always wrap scrollable form pages in `SingleChildScrollView` with `ClampingScrollPhysics`.
- Dismiss keyboard on outside tap using `GestureDetector` with `FocusScope.of(context).unfocus()`.
- Wrap safe areas in `SafeArea`.

---

## 🏷️ 6. Naming & Style Conventions

| Category | Convention | Examples |
| :--- | :--- | :--- |
| **Files & Directories** | `snake_case.dart` | `movie_details_screen.dart`, `auth_cubit.dart` |
| **Classes & Types** | `PascalCase` | `MovieDetailsScreen`, `AuthCubit`, `MovieEntity` |
| **Methods & Variables** | `camelCase` | `getPopularMovies()`, `isLoading`, `movieList` |
| **Constants** | `camelCase` or `UPPER_SNAKE` | `AppColors.primary`, `maxItemCount` |
| **Use Cases** | `<Action><Feature>UseCase` | `GetTrendingMoviesUseCase`, `LoginUseCase` |
| **Cubits & States** | `<Feature>Cubit`, `<Feature>State` | `MoviesCubit`, `MoviesState` |
| **Data Sources** | `<Feature>DataSource`, `*Imp` | `MoviesDataSource`, `MoviesDataSourceImp` |
| **Repositories** | `<Feature>Repo`, `*Imp` | `MoviesRepo`, `MoviesRepoImp` |

---

## 🧪 7. Testing & Quality Standards

### Rule 7.1 — Static Analysis Policy
- The codebase must always maintain **0 errors and 0 warnings** under `flutter analyze`.
- Deprecated methods, unused imports, and dead code must be resolved immediately.

### Rule 7.2 — Testing Coverage Requirements
- **Domain Layer:** Unit-test every UseCase using mocked repository interfaces (`mocktail`).
- **Data Layer:** Test JSON deserialization on Models with sample API fixtures.
- **Presentation Layer:** Test Cubit state transitions using `bloc_test`.
- **Widget Layer:** Smoke test key screens using `flutter_test`.

---

## 🤖 8. AI Agent Specific Instructions

1. **Verify Before Committing:** Always run `flutter analyze` and `flutter test` after modifying any Dart files.
2. **Preserve Documentation Integrity:** Maintain and update `.agent/ARCHITECTURE_NOTES.md`, `.agent/FEATURE_INDEX.md`, and `.agent/FOLDER_GUIDE.md` whenever adding or modifying features.
3. **No Breaking Changes to Package Name:** Ensure `pubspec.yaml` name remains `movie_app` and all package imports use `package:movie_app/...`.
4. **Clean Code Comments:** Do not remove existing informative comments or docstrings unless explicitly requested.
