# 📑 Movie App Features Index & Roadmap

This document serves as the central index of all modules/features in the **Movie & Cinema App** (`movie_app`). It tracks the development status, layer components, use cases, state management, and dependencies for each feature.

---

## 📊 Features Status Matrix

| Feature | Description | Status | Domain Layer | Data Layer | Presentation Layer |
| :--- | :--- | :---: | :---: | :---: | :---: |
| [🚀 Launch & Onboarding (`splash`, `onboarding`)](#-1-app-launch--onboarding) | Splash animation, multi-page intro slider & routing | ✅ Completed | N/A | N/A | ✅ Ready |
| [🔐 Authentication (`auth`)](#-2-authentication-feature-auth) | Login, Register, Google Sign In, Password Reset | ✅ Completed | ✅ Ready | ✅ Ready | ✅ Ready |
| [🧭 Navigation & Main Layout (`layout`)](#-3-navigation--main-layout-layout) | Floating Bottom Navigation Bar, 4 Tab Containers | ✅ Completed | N/A | N/A | ✅ Ready |
| [🎬 Home & Featured Movies (`home`)](#-4-home--featured-movies-home) | Trending, Popular, Top Rated, Now Playing TMDB APIs | ⏳ Planned | ⏳ Planned | ⏳ Planned | ⏳ Planned |
| [🗂️ Movie Genres & Browse (`genres`)](#-5-movie-genres--browse-genres) | Explore by Category (Action, Sci-Fi, Horror, Drama, etc.) | ⏳ Planned | ⏳ Planned | ⏳ Planned | ⏳ Planned |
| [🎞️ Movie Details & Trailer (`details`)](#-6-movie-details--trailer-details) | Overview, Cast, Trailer Player, Rating, Similar Movies | ⏳ Planned | ⏳ Planned | ⏳ Planned | ⏳ Planned |
| [🔍 Search & Filtering (`search`)](#-7-search--filtering-search) | Real-time title search, genre filters, release year | ⏳ Planned | ⏳ Planned | ⏳ Planned | ⏳ Planned |
| [🔖 Watchlist & Favorites (`watchlist`)](#-8-watchlist--favorites-watchlist) | Bookmark movies, offline watch later, mark as watched | ⏳ Planned | ⏳ Planned | ⏳ Planned | ⏳ Planned |
| [👤 User Profile & Settings (`profile`)](#-9-user-profile--settings-profile) | User avatar, watch history, watchlist tabs, profile update & avatar sheet | ✅ Completed | ✅ Ready | ✅ Ready | ✅ Ready |

*Legend: ✅ Completed | 🚧 In Progress | ⏳ Planned*

---

## 🚀 1. App Launch & Onboarding

- **Paths:** `lib/features/auth/presentation/screens/splash/`, `lib/features/auth/presentation/screens/onboarding/`
- **Status:** ✅ Completed
- **Components:**
  - `SplashScreen`: Animated logo fade-in and footer animations via `animate_do`.
  - `OnboardingScreen`: PageView slider displaying movie posters with `OnboardingNormalContent` and `OnboardingBottomContent`.
  - `OnboardingModel`: Multi-slide configuration data.

---

## 🔐 2. Authentication Feature (`auth`)

- **Path:** `lib/features/auth/`
- **Status:** ✅ Completed (Dark Cinema Theme & Google Auth support)
- **Purpose:** Handles user sign in, registration, session persistence, and navigation.

### Layer Map:
```text
lib/features/auth/
├── data/
│   ├── data_source/
│   │   ├── data_source.dart            # AuthDataSource (Contract)
│   │   └── data_source_imp.dart        # AuthDataSourceImp (Implementation)
│   ├── models/
│   │   └── user_model.dart             # UserModel (JSON serialization)
│   └── repo/
│       └── repo_imp.dart               # AuthRepoImp (Implements AuthRepo)
├── domain/
│   ├── entity/
│   │   └── user_entity.dart            # UserEntity (Domain model)
│   ├── repo/
│   │   └── repo.dart                   # AuthRepo (Domain contract)
│   └── use_case/
│       ├── login_use_case.dart         # LoginUseCase
│       └── register_use_case.dart      # RegisterUseCase
└── presentation/
    ├── manager/
    │   ├── auth_cubit.dart             # AuthCubit
    │   └── auth_state.dart             # AuthState (loginState, registerState)
    ├── screens/
    │   ├── splash/                     # SplashScreen
    │   ├── onboarding/                 # OnboardingScreen
    │   ├── auth_screens/
    │   │   ├── login_screen.dart       # LoginScreen (Email/Pass, OR divider, Google Auth)
    │   │   └── register_screen.dart    # RegisterScreen (Mirrored UI, Google Auth)
    │   ├── layout/
    │   │   └── layout_screen.dart      # LayoutScreen (Cinematic 4-tab floating bar)
    │   └── profile/
    │       ├── screens/
    │       │   ├── profile_screen.dart        # ProfileScreen (Avatar, Wishlist & History tabs, Exit)
    │       │   └── update_profile_screen.dart # UpdateProfileScreen (Avatar selector, edit form)
    │       └── widgets/
    │           ├── avatar_picker_sheet.dart   # AvatarPickerSheet (9 movie avatars modal)
    │           ├── custom_text_field.dart     # Profile customized input field
    │           ├── movie_card.dart            # MovieCard widget for watchlist grid
    │           └── profile_button.dart        # ProfileButton widget (Edit profile, Delete, etc.)
    └── widgets/
        ├── auth_button_widget.dart     # AuthButtonWidget (Gold CTA & Google button)
        ├── auth_header_widget.dart     # AuthHeaderWidget (Title & subtitle header)
        ├── auth_prompt_row.dart        # AuthPromptRow (Interactive navigation links)
        ├── custom_text_field.dart      # CustomTextField (Dark card input with gold focus)
        ├── forgot_password_widget.dart # ForgotPasswordWidget (Gold link)
        ├── login_form_widget.dart      # LoginFormWidget (Encapsulated login form)
        ├── register_form_widget.dart   # RegisterFormWidget (Encapsulated register form)
        ├── route_logo_widget.dart      # RouteLogoWidget (Movie branding)
        ├── onboarding_bottom_content.dart
        ├── onboarding_button.dart
        └── onboarding_normal_content.dart
```

---

## 🧭 3. Navigation & Main Layout (`layout`)

- **Path:** `lib/features/auth/presentation/screens/layout/layout_screen.dart`
- **Status:** ✅ Completed
- **Purpose:** Host the 4 primary application tabs via a persistent floating navigation bar:
  - 🎬 **Home View:** Hero banner, Trending Now, and Popular Movies horizontal sections.
  - 🔍 **Search View:** Interactive search bar with genre chips and result placeholders.
  - 🗂️ **Browse View:** Responsive category grid of all film genres.
  - 👤 **Profile View:** Integrated `ProfileScreen` with user avatar, Watchlist and History tabs, Edit Profile, and Logout.

---

## 🎬 4. Home & Featured Movies (`home`)

- **Path:** `lib/features/home/`
- **Status:** ⏳ Planned
- **Purpose:** Connect to TMDB REST APIs to display live trending and popular movie data.

---

## 🗂️ 5. Movie Genres & Browse (`genres`)

- **Path:** `lib/features/genres/`
- **Status:** ⏳ Planned
- **Purpose:** Fetch genre IDs from TMDB and filter movie lists by specific categories.

---

## 🎞️ 6. Movie Details & Trailer (`details`)

- **Path:** `lib/features/details/`
- **Status:** ⏳ Planned
- **Purpose:** Movie overview, video trailer player, cast/crew, user ratings, and similar titles.

---

## 🔍 7. Search & Filtering (`search`)

- **Path:** `lib/features/search/`
- **Status:** ⏳ Planned
- **Purpose:** Real-time search with debounce, search history, year filter, rating filter.

---

## 🔖 8. Watchlist & Favorites (`watchlist`)

- **Path:** `lib/features/watchlist/`
- **Status:** ⏳ Planned
- **Purpose:** Local database persistence (Hive / SQLite) to save movies offline.

---

## 👤 9. User Profile & Settings (`profile`)

- **Path:** `lib/features/auth/presentation/screens/profile/`
- **Status:** ✅ Completed
- **Purpose:** User avatar picker modal, Watchlist & History movie tabbed grid, Update Profile screen, Password Reset, and Account Deletion dialog.
