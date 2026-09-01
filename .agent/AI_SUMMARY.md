# 🤖 AI Context & Project Summary — Movie App

> **Quick AI Briefing:** This document provides an executive summary, architectural overview, tech stack blueprint, and context cheat sheet for AI coding assistants working on the **Route Movie App** codebase.

---

## 📌 1. Project Overview

- **App Name:** `movie_app` (Route Movie & Cinema App)
- **Primary Domain:** Movie discovery, streaming previews, trailer playback, genre browsing, and personal watchlist management.
- **Visual Aesthetic:** **Dark Cinema Theme** (Obsidian `#121312`, Cinema Gold `#FFBB3B`, Slate Surface `#282A28`, Crisp White `#FFFFFF`).
- **Target Platforms:** Android, iOS, Web, Desktop (Linux, macOS, Windows).
- **Core Architecture:** Uncle Bob's **Clean Architecture** with **Feature-First (Vertical Slice)** directory structure and **BLoC / Cubit** for reactive state management.

---

## 🛠️ 2. Tech Stack & Key Dependencies

| Component | Technology / Library | Description |
| :--- | :--- | :--- |
| **Language** | Dart `^3.12.2` | Strong null safety, sealed classes, records |
| **Framework** | Flutter SDK (Material 3) | Declarative UI toolkit with dark brightness default |
| **State Management** | `flutter_bloc: ^8.1.6` | Lightweight `Cubit` pattern with immutable states |
| **Icons & Assets** | `cupertino_icons: ^1.0.8` | Cupertino and Material symbols |
| **Architecture Pattern** | Clean Architecture (Feature-First) | Decoupled Domain, Data, and Presentation layers |
| **Styling & Theming** | `AppColors` & `AppTheme` | Centralized design tokens and dark cinema theme |

---

## 🏛️ 3. High-Level Architectural Flow

```
┌────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                            │
│   Screens (Smart Containers) ──▶ Cubits (State Machines) ──▶ Widgets   │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ Calls UseCases
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                             DOMAIN LAYER                               │
│     UseCases (Interactors) ──▶ Entities (Pure Dart Business Models)    │
│                     ▲                                                  │
│                     └─── Contracts: Repository Interfaces              │
└───────────────────────────────────▲────────────────────────────────────┘
                                    │ Implements
┌───────────────────────────────────┴────────────────────────────────────┐
│                              DATA LAYER                                │
│   Repo Implementations ──▶ Models/DTOs (JSON Mappers) ──▶ Data Sources  │
│                                              (Remote API & Local Cache)│
└────────────────────────────────────────────────────────────────────────┘
```

---

## 📁 4. Directory & Module Map

```text
movie_app/
├── .agent/                             # AI context, architecture notes & roadmap
│   ├── AI_SUMMARY.md                   # This executive summary
│   ├── ARCHITECTURE_NOTES.md           # Deep architectural decisions
│   ├── DEVELOPMENT_RULES.md            # Mandatory development & coding rules
│   ├── FEATURE_INDEX.md                # Feature roadmap & layer status
│   └── FOLDER_GUIDE.md                 # Detailed folder guide & tutorials
│
├── lib/
│   ├── core/                           # Universal shared components
│   │   ├── services/                   # Network clients, interceptors, caching
│   │   ├── states/                     # Generic UI states (BaseState, Loading, Success, Error)
│   │   ├── theme/                      # AppColors, AppTheme (Cinema Dark Theme)
│   │   └── widgets/                    # Global reusable UI widgets
│   │
│   ├── features/                       # Feature-first modular slices
│   │   ├── auth/                       # [✅ Completed] Sign In, Sign Up, Forms & Cubit
│   │   ├── home/                       # [⏳ Planned] Trending, Popular, Top Rated carousels
│   │   ├── genres/                     # [⏳ Planned] Movie genres & category exploration
│   │   ├── details/                    # [⏳ Planned] Movie backdrop, trailer player, cast
│   │   ├── search/                     # [⏳ Planned] Debounced search & filter sheet
│   │   ├── watchlist/                  # [⏳ Planned] Saved movies & offline bookmarks
│   │   └── profile/                    # [⏳ Planned] User preferences & watch history
│   │
│   └── main.dart                       # Entry point, AppTheme.darkTheme, AuthCubit provider
│
└── test/                               # Unit, widget, and bloc test suites
    └── widget_test.dart
```

---

## 🔐 5. Feature Status Summary

### 1. Authentication (`lib/features/auth/`) — **Status: ✅ Completed**
- **Domain:** `UserEntity`, `AuthRepo`, `LoginUseCase`, `RegisterUseCase`.
- **Data:** `UserModel`, `AuthDataSource` (interface), `AuthDataSourceImp`, `AuthRepoImp`.
- **Presentation:**
  - **Manager:** `AuthCubit`, `AuthState` (managing `loginState` and `registerState`).
  - **Screens:** `LoginScreen`, `RegisterScreen` (with dark cinema layout, keyboard dismissal).
  - **Widgets:** `RouteLogoWidget` (`MovieLogoWidget`), `AuthHeaderWidget`, `CustomTextField`, `AuthButtonWidget`, `AuthPromptRow`, `ForgotPasswordWidget`, `LoginFormWidget`, `RegisterFormWidget`.

### 2. Upcoming Features Roadmap
- **🎬 Home:** Featured carousel, Trending Today, Popular Movies, Top Rated, Now Playing.
- **🗂️ Genres:** Category grid, Genre chip filters, Category movie lists.
- **🎞️ Details:** Backdrop banner, Video trailer player, Cast & crew cards, Overview, Similar movies.
- **🔍 Search:** Live search query with debounce, Search history, Year and rating filters.
- **🔖 Watchlist:** Bookmark toggle, Local storage persistence (Hive / SharedPreferences).
- **👤 Profile:** User profile display, Preferences, Theme switcher.

---

## 🎨 6. Design System & Brand Palette

All UI components MUST consume tokens from `lib/core/theme/app_colors.dart`:

```dart
// Cinema Design Tokens
AppColors.primary          // #FFBB3B (Cinema Gold - CTAs, active highlights)
AppColors.background       // #121312 (Deep Obsidian Dark Background)
AppColors.cardBackground   // #1E1E1E (Elevated Card Background)
AppColors.surface          // #282A28 (Input Field Fill & Surface)
AppColors.textWhite        // #FFFFFF (High-emphasis text & titles)
AppColors.textGrey         // #CBCBCB (Medium-emphasis body text)
AppColors.textDark         // #121312 (Text on primary gold buttons)
AppColors.inputBorder      // #383B38 (Subtle unselected input borders)
AppColors.error            // #E53935 (Validation error text & borders)
AppColors.success          // #43A047 (Success snackbars & indicators)
```

---

## 🤖 7. Guidelines for AI Agents

When implementing new features, fixing bugs, or refactoring in this repository:
1. **Respect Layer Boundaries:** Never import `data/` or `presentation/` classes inside `domain/`.
2. **Follow Feature-First Organization:** Place all feature code in `lib/features/<feature_name>/` divided into `domain/`, `data/`, and `presentation/`.
3. **Use Immutable State:** Always emit new state instances in Cubits using `copyWith()`.
4. **Maintain Pure Domain Entities:** Keep `Entity` classes free from `fromJson` or `toJson` logic (place serialization in `Model` classes).
5. **Dark Cinema Consistency:** Always use `AppColors` tokens and dark cinema styling.
6. **Zero Analysis Errors:** Always ensure `flutter analyze` passes with **0 errors and 0 warnings**.
