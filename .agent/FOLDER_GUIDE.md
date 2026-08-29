# 📁 Project Folder & Architecture Guide

Welcome to the **E-Commerce App** Flutter project guide! This document outlines the project structure, architectural patterns, layer responsibilities, data flow, and step-by-step conventions for building new features.

---

## 🏗️ Architecture Overview

This project is built following **Clean Architecture (Feature-First approach)** paired with the **BLoC / Cubit** pattern for state management.

```
       ┌──────────────────────────────────────────────────┐
       │               PRESENTATION LAYER                 │
       │    (Screens, Widgets, Cubits/Blocs, States)      │
       └─────────────────────────┬────────────────────────┘
                                 │ Calls
                                 ▼
       ┌──────────────────────────────────────────────────┐
       │                  DOMAIN LAYER                    │
       │  (Business Logic, Entities, Use Cases, Repos)    │
       └─────────────────────────▲────────────────────────┘
                                 │ Implements
                                 │ (Dependency Inversion)
       ┌─────────────────────────┴────────────────────────┐
       │                   DATA LAYER                     │
       │  (Data Sources, Models/DTOs, Repo Implementations)│
       └──────────────────────────────────────────────────┘
```

### Key Architectural Principles
- **Separation of Concerns:** Each layer has a distinct responsibility and is decoupled from outer dependencies.
- **Dependency Inversion:** Domain is the central layer. It does not depend on Data or Presentation. Data implements interfaces defined by Domain.
- **Feature-First Organization:** Every feature (e.g., `auth`, `products`, `cart`) is modular and self-contained with its own Presentation, Domain, and Data layers.
- **Shared Core:** Reusable components, base states, themes, network clients, and utilities live in `lib/core/`.

---

## 📂 Root Directory Structure

```text
e_commerce_app/
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
└── FOLDER_GUIDE.md        # This architectural and folder guide
```

---

## 📦 `lib/` Directory Breakdown

```text
lib/
├── core/                                # Reusable & shared global utilities
│   ├── services/                        # App-wide services (API clients, storage, network)
│   ├── states/                          # Global base states (e.g., BaseState)
│   │   └── base_state.dart
│   ├── theme/                           # App themes, colors, typography, styles
│   └── widgets/                         # Reusable global widgets (buttons, text fields, loaders)
│
├── features/                            # Feature-first modules
│   └── auth/                            # Authentication Feature Module
│       ├── data/                        # Data Layer (Remote & Local data)
│       │   ├── data_source/             # API calls and local DB interactions
│       │   │   ├── data_source.dart     # Abstract data source contract
│       │   │   └── data_source_imp.dart # Concrete implementation
│       │   ├── models/                  # JSON/DTO models with serialization logic
│       │   └── repo/                    # Repository implementations
│       │       └── repo_imp.dart        # Implements domain repository contract
│       │
│       ├── domain/                      # Domain Layer (Pure business logic)
│       │   ├── entity/                  # Pure Dart domain entities (e.g., UserEntity)
│       │   ├── repo/                    # Abstract repository interfaces (contracts)
│       │   │   └── repo.dart
│       │   └── use_case/                # Single-responsibility business use cases
│       │       └── login_use_case.dart
│       │
│       └── presentation/                # Presentation Layer (UI & State)
│           ├── manager/                 # Cubits / Blocs and UI States
│           │   ├── auth_cubit.dart
│           │   └── auth_state.dart
│           ├── screens/                 # Full screen widgets (e.g., LoginScreen)
│           └── widgets/                 # Feature-specific UI widgets
│
└── main.dart                            # Application entry point
```

---

## 🔍 Detailed Layer Responsibilities

### 1. `lib/core/` (Shared Layer)
Contains code that is shared across multiple features. It must not depend on any specific feature.

| Subfolder | Purpose & Contents |
| :--- | :--- |
| `services/` | Network helpers (Dio/Http), local caching (SharedPreferences, Hive, SecureStorage), error handling/interceptors. |
| `states/` | Shared state definitions (e.g., `BaseState`, `LoadingState`, `SuccessState`, `ErrorState`). |
| `theme/` | Color palette (`AppColors`), text styles (`AppTypography`), theme configurations (`AppTheme`). |
| `widgets/` | Common reusable UI components (e.g., `CustomButton`, `CustomTextField`, `LoadingIndicator`). |

---

### 2. `lib/features/<feature_name>/` (Feature Modules)

Each feature is divided into three layers:

#### A. Data Layer (`features/<feature>/data/`)
Responsible for retrieving and persisting data from remote APIs or local databases.
- **`data_source/`**: Handles raw network requests or database queries.
  - `*_data_source.dart`: Interface definition.
  - `*_data_source_imp.dart`: Actual implementation (e.g., using `Dio`, `http`, or local DB).
- **`models/`**: Extends or converts to Domain Entities. Handles `fromJson`, `toJson`, and serialization.
- **`repo/`**: Implements the repository interface defined in the domain layer (`*_repo_imp.dart`). Gathers data from data sources and maps models to entities.

#### B. Domain Layer (`features/<feature>/domain/`)
The core business logic layer. Contains pure Dart code with **no UI or external library dependencies**.
- **`entity/`**: Core business models (plain Dart classes representing business data).
- **`repo/`**: Abstract interfaces defining data contracts (e.g., `AuthRepo`).
- **`use_case/`**: Single-purpose interactors executing a business operation (e.g., `LoginUseCase`, `RegisterUseCase`).

#### C. Presentation Layer (`features/<feature>/presentation/`)
Responsible for rendering the UI and handling user interaction.
- **`manager/`**: State management logic using Cubit/Bloc:
  - `*_cubit.dart`: Manages state and calls use cases.
  - `*_state.dart`: Defines immutable states representing UI conditions.
- **`screens/`**: Complete screen views (e.g., `LoginScreen`, `RegisterScreen`).
- **`widgets/`**: UI components specific only to this feature (e.g., `LoginFormField`, `AuthHeader`).

---

## 🔄 Data & Control Flow

Here is how data and actions flow through the app during a user operation (e.g., User Login):

```text
[ User clicks "Login" ]
        │
        ▼
[ Presentation - Screen / Widget ]
        │ Calls
        ▼
[ Presentation - Cubit (e.g. AuthCubit) ]
        │ Emits LoadingState
        │ Executes UseCase
        ▼
[ Domain - UseCase (e.g. LoginUseCase) ]
        │ Calls abstract repository method
        ▼
[ Data - Repository Implementation (e.g. AuthRepoImp) ]
        │ Calls DataSource
        ▼
[ Data - Remote DataSource (e.g. AuthRemoteDataSourceImp) ]
        │ Performs API / HTTP Call
        ▼
[ Backend API / Server ]
        │ Returns JSON Response
        ▼
[ Data - Model (e.g. UserModel) ] (Parses JSON)
        │
        ▼
[ Data - Repository Implementation ] (Returns Entity / Result)
        │
        ▼
[ Domain - UseCase ]
        │ Returns Result to Cubit
        ▼
[ Presentation - Cubit ]
        │ Emits SuccessState or ErrorState
        ▼
[ Presentation - Screen / Widget ] (Rebuilds UI with new state)
```

---

## 🚀 How to Add a New Feature

When creating a new feature (e.g., `products`), follow these steps in order:

### Step 1: Domain Layer (Define contracts & logic)
1. **Entity**: Create `lib/features/products/domain/entity/product_entity.dart`.
2. **Repository Contract**: Create `lib/features/products/domain/repo/products_repo.dart`.
3. **Use Cases**: Create use cases such as `get_products_use_case.dart`.

### Step 2: Data Layer (Implement data fetching)
1. **Model**: Create `lib/features/products/data/models/product_model.dart` (handles JSON serialization and maps to `ProductEntity`).
2. **Data Source**:
   - `lib/features/products/data/data_source/products_data_source.dart` (Interface)
   - `lib/features/products/data/data_source/products_data_source_imp.dart` (Implementation)
3. **Repository Implementation**:
   - `lib/features/products/data/repo/products_repo_imp.dart` (Implements `ProductsRepo`).

### Step 3: Presentation Layer (UI & State Management)
1. **Manager**:
   - Create `products_state.dart` (define states: Initial, Loading, Success, Error).
   - Create `products_cubit.dart` (calls use case and emits states).
2. **Widgets & Screens**:
   - Create screen in `lib/features/products/presentation/screens/products_screen.dart`.
   - Create reusable sub-components in `lib/features/products/presentation/widgets/`.

---

## 🏷️ Naming Conventions

To maintain clean and consistent code across the team:

| Item | Naming Pattern | Example |
| :--- | :--- | :--- |
| **Files** | `snake_case.dart` | `login_use_case.dart`, `auth_cubit.dart` |
| **Classes** | `PascalCase` | `LoginUseCase`, `AuthCubit`, `UserEntity` |
| **Variables & Functions** | `camelCase` | `isLogin`, `fetchProducts()`, `userData` |
| **Entities** | `<Name>Entity` | `UserEntity`, `ProductEntity` |
| **Models** | `<Name>Model` | `UserModel`, `ProductModel` |
| **Repositories (Domain)** | `<Name>Repo` | `AuthRepo`, `ProductsRepo` |
| **Repositories (Data)** | `<Name>RepoImp` | `AuthRepoImp`, `ProductsRepoImp` |
| **Use Cases** | `<Action><Feature>UseCase` | `LoginUseCase`, `GetCategoriesUseCase` |
| **Cubits** | `<Feature>Cubit` | `AuthCubit`, `CartCubit` |
| **States** | `<Feature>State` | `AuthState`, `CartState` |
| **Screens** | `<Feature>Screen` / `<Feature>View` | `LoginScreen`, `HomeScreen` |

---

## 💡 Best Practices

1. **Keep Domain Pure**: Never import Flutter UI packages (`material.dart`, `widgets.dart`) or Data layer classes inside the `domain` folder.
2. **Use Single Responsibility**: Each usecase should execute exactly one business task.
3. **Handle Errors Gracefully**: Catch exceptions in the data layer / repository and return functional error types (e.g., `Either<Failure, Success>` or custom Result objects).
4. **State Immutability**: Ensure states emitted by Cubits/Blocs are immutable.
5. **Reusable Widgets**: If a widget is used in multiple features, place it in `lib/core/widgets/`. If it's used only within one feature, place it in that feature's `presentation/widgets/`.
