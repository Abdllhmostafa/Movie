abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final List<Map<String, String>> wishlistMovies;
  final List<Map<String, String>> watchlistMovies;
  final List<Map<String, String>> historyMovies;

  ProfileLoadedState({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.wishlistMovies,
    this.watchlistMovies = const [],
    required this.historyMovies,
  });

  ProfileLoadedState copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    List<Map<String, String>>? wishlistMovies,
    List<Map<String, String>>? watchlistMovies,
    List<Map<String, String>>? historyMovies,
  }) {
    return ProfileLoadedState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      wishlistMovies: wishlistMovies ?? this.wishlistMovies,
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      historyMovies: historyMovies ?? this.historyMovies,
    );
  }
}

class ProfileUpdateSuccessState extends ProfileState {
  final String message;
  ProfileUpdateSuccessState({this.message = "Profile updated successfully"});
}

class ProfilePasswordResetSentState extends ProfileState {
  final String email;
  ProfilePasswordResetSentState({required this.email});
}

class ProfileSignOutSuccessState extends ProfileState {}

class ProfileDeleteAccountSuccessState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}
