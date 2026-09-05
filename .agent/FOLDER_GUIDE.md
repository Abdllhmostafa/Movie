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
├── assets/                # App images, logos, movie posters
│   ├── images/
│   └── logos/
├── lib/                   # Main Dart/Flutter source code
├── test/                  # Unit, widget, and integration tests
├── pubspec.yaml           # App dependencies, assets, fonts, and metadata
├── analysis_options.yaml  # Linting and static analysis rules
├── README.md              # Project general readme
└── .agent/                # AI Agent architecture and feature index guides
    ├── AI_SUMMARY.md
    ├── ARCHITECTURE_NOTES.md
    ├── DEVELOPMENT_RULES.md
    ├── FEATURE_INDEX.md
    └── FOLDER_GUIDE.md
```

---

## 📦 `lib/` Directory Breakdown

```text
lib/
├── core/                                # Shared global utilities
│   ├── routes/                          # AppRouters & RouteName constants
│   │   ├── app_routers.dart
│   │   └── route_name.dart
│   ├── services/                        # App-wide services (API clients, storage, network)
│   ├── states/                          # Global base states (e.g., BaseState)
│   │   └── base_state.dart
│   ├── theme/                           # Dark Cinema palette & typography
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── widgets/                         # Reusable global UI widgets
│
├── features/                            # Feature-first modules
│   └── auth/                            # Authentication, Onboarding & Layout
│       ├── data/                        # Data Layer (Remote & Local data)
│       │   ├── data_source/
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
│           │   ├── splash/
│           │   │   └── splash_screen.dart
│           │   ├── onboarding/
│           │   │   ├── onboarding_model.dart
│           │   │   └── onboarding_screen.dart
│           │   ├── auth_screens/
│           │   │   ├── login_screen.dart
│           │   │   └── register_screen.dart
│           │   ├── layout/
│           │   │   └── layout_screen.dart
│           │   └── profile/
│           │       ├── screens/
│           │       │   ├── profile_screen.dart
│           │       │   └── update_profile_screen.dart
│           │       └── widgets/
│           │           ├── avatar_picker_sheet.dart
│           │           ├── custom_text_field.dart
│           │           ├── movie_card.dart
│           │           └── profile_button.dart
│           └── widgets/                 # Feature-specific UI widgets
│               ├── auth_button_widget.dart
│               ├── auth_header_widget.dart
│               ├── auth_prompt_row.dart
│               ├── custom_text_field.dart
│               ├── forgot_password_widget.dart
│               ├── login_form_widget.dart
│               ├── register_form_widget.dart
│               ├── route_logo_widget.dart
│               ├── onboarding_bottom_content.dart
│               ├── onboarding_button.dart
│               └── onboarding_normal_content.dart
│
└── main.dart                            # Application entry point
```

---

## 🚦 Navigation Routes Map

| Route Constant | Screen Widget | Description |
| :--- | :--- | :--- |
| `RouteName.splash` (`/`) | `SplashScreen` | Animated branding intro |
| `RouteName.onBoarding` (`onBoarding`) | `OnboardingScreen` | Interactive poster slider |
| `RouteName.login` (`login`) | `LoginScreen` | Sign In, OR divider, Google Auth |
| `RouteName.register` (`register`) | `RegisterScreen` | Create Account, Google Auth |
| `RouteName.layout` (`layout`) | `LayoutScreen` | Floating Nav Bar (Home, Search, Browse, Profile) |
| `RouteName.profile` (`profile`) | `ProfileScreen` | Profile, Watchlist & History tabs, Exit dialog |
| `RouteName.updateProfileScreen` (`updateProfileScreen`) | `UpdateProfileScreen` | Avatar Picker Modal, Edit Name/Phone, Reset Password |

