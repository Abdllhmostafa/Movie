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
| **Responsive Sizing** | `flutter_screenutil: ^5.9.3` | Responsive UI scaling across all mobile screen dimensions |
| **Animations** | `animate_do: ^5.1.0` | Fade and slide entrance animations for Splash and Onboarding |
| **Icons & Assets** | `cupertino_icons: ^1.0.8`, `flutter_svg: ^2.0.17`, `lottie: ^3.3.1` | Cupertino/Material icons, SVG vector graphics, Lottie animations |
| **Navigation & Routing** | `AppRouters` & `RouteName` | Centralized named routing system |
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
│   │   ├── constants/                  # AppAssets paths
│   │   ├── routes/                     # AppRouters & RouteName constants
│   │   ├── services/                   # Network clients, interceptors, caching
│   │   ├── states/                     # Generic UI states (BaseState, Loading, Success, Error)
│   │   ├── theme/                      # AppColors, AppTheme (Cinema Dark Theme)
│   │   └── widgets/                    # Global reusable UI widgets
│   │
│   ├── features/                       # Feature-first modular slices
│   │   └── auth/                       # [✅ Completed] Splash, Onboarding, Login, Register, Layout, Profile
│   │       ├── data/                   # Data sources, UserModel, RepoImp
│   │       ├── domain/                 # UserEntity, AuthRepo, Login/Register UseCases
│   │       └── presentation/
│   │           ├── manager/            # AuthCubit & AuthState
│   │           ├── screens/
│   │           │   ├── splash/         # SplashScreen with animate_do
│   │           │   ├── onboarding/     # OnboardingScreen (multi-page slider)
│   │           │   ├── auth_screens/   # LoginScreen & RegisterScreen (with Google auth & OR divider)
│   │           │   ├── layout/         # LayoutScreen (Floating nav bar: Home, Search, Browse, Profile)
│   │           │   └── profile/        # ProfileScreen & UpdateProfileScreen
│   │           │       ├── screens/    # ProfileScreen, UpdateProfileScreen
│   │           │       └── widgets/    # AvatarPickerSheet, ProfileButton, MovieCard, CustomTextField
│   │           └── widgets/            # Modular reusable auth and cinema widgets
│   │
│   └── main.dart                       # Entry point, ScreenUtilInit, AppTheme.darkTheme, AuthCubit
│
└── test/                               # Unit, widget, and bloc test suites
    └── widget_test.dart
```

---

## 🔐 5. Feature Status Summary

### 1. App Launch & Onboarding — **Status: ✅ Completed**
- **Splash Screen:** Animated Route logo entrance with `animate_do` fading effects.
- **Onboarding Screen:** Interactive multi-page poster carousel with custom slide layouts (`OnboardingNormalContent` and `OnboardingBottomContent`).

### 2. Authentication Flow — **Status: ✅ Completed**
- **Domain:** `UserEntity`, `AuthRepo`, `LoginUseCase`, `RegisterUseCase`.
- **Data:** `UserModel`, `AuthDataSource` (interface), `AuthDataSourceImp`, `AuthRepoImp`.
- **Presentation:**
  - **Login Screen:** App logo, clean email & password inputs, forgot password link, Sign In button, OR divider, Google sign-in button.
  - **Register Screen:** Mirrored cinema UI, full name, email, password, confirm password, mobile number, Create Account button, OR divider, Google sign-in button.

### 3. Main Cinema Layout & Navigation — **Status: ✅ Completed**
- **Floating Bottom Navigation Bar:** Frosted dark slate pill bar with gold active states.
- **Tabs:**
  - 🎬 **Home:** Featured movie hero card, Trending Now horizontal slider, Popular Movies horizontal slider.
  - 🔍 **Search:** Search bar with gold prefix icon, category filter chips, search suggestion state.
  - 🗂️ **Browse:** Grid of cinema genre categories (Action, Sci-Fi, Horror, Drama, Animation, etc.).
  - 👤 **Profile:** Integrated `ProfileScreen` as Tab 3 with Watchlist & History tabs, edit profile navigation, and logout.

### 4. User Profile & Profile Update — **Status: ✅ Completed**
- **Profile Screen:** User avatar, name/email header, Watchlist & History tabbed movie grids with empty state animations, Edit Profile CTA button, and Exit/Log Out dialog.
- **Update Profile Screen:** Interactive avatar selection modal (`AvatarPickerSheet` with 9 preset movie avatar options), profile edit form, Reset Password trigger, and Delete Account dialog.

---

## 🎨 6. Design System & Brand Palette

All UI components MUST consume tokens from `lib/core/theme/app_colors.dart`:

```dart
// Cinema Design Tokens
AppColors.primary          // #FFBB3B (Cinema Gold - CTAs, active highlights)
AppColors.background       // #121312 (Deep Obsidian Dark Background)
AppColors.cardBackground   // #1E1E1E (Elevated Card Background)
AppColors.surface          // #282A28 (Input Field Fill, Floating Bar & Surface)
AppColors.textWhite        // #FFFFFF (High-emphasis text & titles)
AppColors.textGrey         // #CBCBCB (Medium-emphasis body text)
AppColors.textDark         // #121312 (Text on primary gold buttons)
AppColors.inputBorder      // #383B38 (Subtle unselected input borders)
AppColors.error            // #E53935 (Validation error text & borders)
AppColors.success          // #43A047 (Success snackbars & indicators)
```
