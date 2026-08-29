# 🏛️ Architecture Notes & Design Decisions

This document contains in-depth architectural notes, design decisions, principles, and guidelines adopted in this Flutter E-Commerce project.

---

## 🎯 1. Architectural Philosophy

The architecture of this project is based on **Clean Architecture (Uncle Bob)** combined with a **Feature-First (Vertical Slice)** organization and the **BLoC / Cubit** state management pattern.

### Core Objectives
1. **Testability:** Business logic and use cases can be unit-tested in isolation without starting a Flutter UI test or running an emulator.
2. **Maintainability:** Code is modularized by feature. Changes to one feature (e.g. `auth`) do not break unrelated features (e.g. `cart`).
3. **Framework Independence:** The core business rules (Domain layer) are written in pure Dart and do not depend on Flutter, UI frameworks, or third-party libraries (e.g. Dio, SharedPreferences).
4. **Scalability:** New features can be developed in parallel by multiple developers following standard layer conventions.

---

## 📐 2. The Dependency Rule

The fundamental rule of Clean Architecture is: **Dependencies can only point inward**.

```
    ┌─────────────────────────────────────────────────────────────┐
    │                    PRESENTATION LAYER                       │
    │              (Flutter UI, Widgets, Cubits)                  │
    │                              │                              │
    │                              ▼ depends on                   │
    │               ┌─────────────────────────────┐               │
    │               │        DOMAIN LAYER         │               │
    │               │  (Entities, Use Cases,      │               │
    │               │   Repository Contracts)     │               │
    │               └─────────────────────────────┘               │
    │                              ▲ implemented by               │
    │                              │                              │
    │                      DATA LAYER                             │
    │       (Data Sources, Models/DTOs, Repo Implementations)     │
    └─────────────────────────────────────────────────────────────┘
```

- **Domain Layer is completely independent:** It knows nothing about the Data layer or the Presentation layer.
- **Data Layer depends on Domain Layer:** It implements the interfaces defined in Domain.
- **Presentation Layer depends on Domain Layer:** It executes Use Cases provided by Domain.

---

## 🔬 3. In-Depth Layer Breakdown & Notes

### 🟢 A. Domain Layer (`lib/features/<feature>/domain/`)
The central layer containing pure enterprise and business rules.

#### 1. Entities (`domain/entity/`)
- **What they are:** Plain Dart objects that represent core business concepts (e.g., `UserEntity`, `ProductEntity`).
- **Rules:**
  - **No** `fromJson` / `toJson` methods inside Entities (leave serialization to Models).
  - Use `final` immutable fields.
  - Implement equality (`Equatable` or Dart 3 `sealed` / `record` patterns) for value-comparison.

#### 2. Repository Contracts (`domain/repo/`)
- **What they are:** Abstract classes/interfaces that define *what* data operations can be performed, but **not** *how* they are fetched.
- **Example:**
  ```dart
  abstract class AuthRepo {
    Future<Either<Failure, UserEntity>> login(String email, String password);
  }
  ```

#### 3. Use Cases / Interactors (`domain/use_case/`)
- **What they are:** Classes encapsulating a **single, specific business action**.
- **Rules:**
  - Each use case should follow Single Responsibility.
  - Use the `call()` method for a clean, callable syntax (`loginUseCase(email, password)`).
  - Use cases call the repository interface and return results/entities to the Cubit.

---

### 🔵 B. Data Layer (`lib/features/<feature>/data/`)
Responsible for data retrieval, persistence, and external communication.

#### 1. Models / DTOs (`data/models/`)
- **What they are:** Data Transfer Objects extending or converting to Entities.
- **Responsibilities:**
  - JSON serialization (`fromJson` and `toJson`).
  - Mapping server response structure to clean Domain Entities:
    ```dart
    class UserModel extends UserEntity {
      UserModel({required super.id, required super.name, required super.email});

      factory UserModel.fromJson(Map<String, dynamic> json) {
        return UserModel(
          id: json['id'] as String,
          name: json['name'] as String,
          email: json['email'] as String,
        );
      }

      Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
    }
    ```

#### 2. Data Sources (`data/data_source/`)
- **Remote Data Source:** Directly interacts with network APIs (REST API, GraphQL) via HTTP clients (e.g., `Dio`).
- **Local Data Source:** Directly interacts with local storage (e.g., `SharedPreferences`, `Hive`, `SQLite`, `FlutterSecureStorage`).
- **Interface Segregation:** Always define an abstract class (e.g., `AuthDataSource`) and implement it in `AuthDataSourceImp`.

#### 3. Repository Implementations (`data/repo/`)
- **Responsibilities:**
  - Coordinates between Remote and Local Data Sources.
  - Catches raw exceptions (e.g. `DioException`, `SocketException`) and maps them into domain `Failure` objects.
  - Returns `Domain Entities` rather than raw `Data Models` to caller use cases.

---

### 🟠 C. Presentation Layer (`lib/features/<feature>/presentation/`)
Responsible for everything the user sees and interacts with.

#### 1. State Management with Cubit (`presentation/manager/`)
- **Why Cubit over Bloc?** Cubits offer a more lightweight and straightforward API using methods rather than event classes, while preserving full unidirectional data flow and state emission.
- **State Modeling:**
  - States represent discrete UI states (Initial, Loading, Success, Error).
  - Use `BaseState` inheritance or sealed classes for exhaustive `switch` pattern-matching in Dart 3:
    ```dart
    sealed class AuthState {}
    class AuthInitialState extends AuthState {}
    class AuthLoadingState extends AuthState {}
    class AuthSuccessState extends AuthState { final UserEntity user; AuthSuccessState(this.user); }
    class AuthErrorState extends AuthState { final String message; AuthErrorState(this.message); }
    ```

#### 2. Separation of Widgets (`presentation/screens/` vs `presentation/widgets/`)
- **Screens (Smart / Container Widgets):**
  - High-level page widgets containing `Scaffold`, `BlocProvider`, `BlocConsumer`, or `BlocListener`.
  - Listen for side-effects (snackbars, dialogs, navigation) and orchestrate screen layout.
- **Widgets (Dumb / Presentational Widgets):**
  - Small, modular sub-components.
  - Receive data via parameters and trigger callbacks on user interaction.
  - No direct business logic or repository calls.

---

### 🟣 D. Core Layer (`lib/core/`)
Cross-cutting shared components used across the entire application:

- `core/services/`: Network clients (`DioFactory`), interceptors (logging, auth token injection), cache helpers.
- `core/states/`: Base state representations (`BaseState`).
- `core/theme/`: Colors (`AppColors`), text themes, dark/light mode configurations.
- `core/widgets/`: Universal widgets (`CustomElevatedButton`, `AppTextInput`, `AppLoader`).

---

## ⚡ 4. Error Handling Strategy

Never let raw exceptions bubble directly to the UI. Use structured functional error handling:

```
[ Data Source throws Exception ]
               │
               ▼
[ Repository catches Exception and maps to Failure ]
               │ (Returns Either<Failure, Data>)
               ▼
[ UseCase forwards Failure ]
               │
               ▼
[ Cubit maps Failure to User-Friendly Message in State ]
               │ (Emits ErrorState(errorMessage))
               ▼
[ UI displays Snackbar / Dialog / Error Widget ]
```

### Standard Failure Classes:
- `ServerFailure`: HTTP 4xx / 5xx error responses from the backend.
- `NetworkFailure`: No internet connection or socket timeout.
- `CacheFailure`: Local storage retrieval or persistence errors.
- `ValidationFailure`: Invalid input or form data.

---

## 💉 5. Dependency Injection (DI) Guidelines

To adhere to Dependency Inversion:
- Use a Service Locator (e.g., `get_it`) to inject dependencies lazily.
- Follow the dependency creation chain:
  $$\text{Data Sources} \rightarrow \text{Repositories} \rightarrow \text{Use Cases} \rightarrow \text{Cubits}$$

```dart
// Example Service Locator Registration Pattern
final getIt = GetIt.instance;

void setupServiceLocator() {
  // 1. Data Sources
  getIt.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImp(getIt<Dio>()));

  // 2. Repositories
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImp(getIt<AuthDataSource>()));

  // 3. Use Cases
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepo>()));

  // 4. Cubits (Factory -> new instance per screen)
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<LoginUseCase>()));
}
```

---

## 🚫 6. Dos and Don'ts (Architecture Guardrails)

| ✅ DO | ❌ DON'T |
| :--- | :--- |
| **Keep Domain pure Dart** without importing `package:flutter/...`. | **Never** import UI or Flutter packages inside the Domain layer. |
| **Emit immutable states** from Cubits. | **Never** mutate state properties directly without `emit()`. |
| **Map Models to Entities** in the Data layer before returning to Domain. | **Never** pass raw JSON maps or Data Models directly to the UI. |
| **Use `BlocListener`** for side effects (navigation, toast, snackbar). | **Never** perform navigation directly inside Cubit functions. |
| **Inject dependencies** via constructor parameters. | **Never** instantiate repositories or data sources directly with `new` inside Cubits. |
| **Keep Use Cases single-purpose** with one main `call()` method. | **Never** bundle multiple unrelated actions into one massive Use Case. |

---

## 🧪 7. Testing Strategy

1. **Domain Layer (Unit Tests):** Test Use Cases with mocked Repository interfaces (using `mocktail` or `mockito`).
2. **Data Layer (Unit Tests):** Test Repository implementations and Data Source serialization against mock API responses.
3. **Presentation Layer (Cubit Tests):** Test Cubit state transitions using `bloc_test` (asserting exact expected state sequences).
4. **Widget Tests:** Test individual UI widgets and interaction behaviors in isolation.
