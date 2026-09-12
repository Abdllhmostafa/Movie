enum OnboardingLayout { normal, bottomSheet }

class OnboardingModel {
  final String imagePath;
  final String title;
  final String? supTitle;
  final String textBttn;
  final String? secondTextBttn;
  final OnboardingLayout layout;

  OnboardingModel({
    required this.title,
    required this.imagePath,
    this.supTitle,
    required this.textBttn,
    this.secondTextBttn,
    required this.layout,
  });

  static List<OnboardingModel> onBoardingList = [
    OnboardingModel(
      title: 'Find Your Next\n Favorite Movie Here',
      imagePath: 'assets/images/movie_poster.png',
      supTitle:
          'Get access to a huge library of movies\n to suit all tastes. You will surely like it.',
      textBttn: 'Explore Now',
      layout: OnboardingLayout.normal,
    ),
    OnboardingModel(
      title: 'Discover Movies',
      imagePath: 'assets/images/movie_poster_spiderman.jpg',
      supTitle:
          'Explore a vast collection of movies in all\n qualities and genres. Find your next\n favorite film with ease.',
      textBttn: 'Next',
      layout: OnboardingLayout.bottomSheet,
    ),
    OnboardingModel(
      title: 'Explore All Genres',
      imagePath: 'assets/images/movie_poster_goodfather.jpg',
      supTitle:
          'Discover movies from every genre, in all\n available qualities. Find something new\n and exciting to watch every day.',
      textBttn: 'Next',
      secondTextBttn: 'Back',
      layout: OnboardingLayout.bottomSheet,
    ),
    OnboardingModel(
      title: 'Create Watchlists',
      supTitle:
          'Save movies to your watchlist to keep\n track of what you want to watch next.\n Enjoy films in various qualities and\n genres.',
      imagePath: 'assets/images/movie_poster_rideordie.jpg',
      textBttn: 'Next',
      secondTextBttn: 'Back',
      layout: OnboardingLayout.bottomSheet,
    ),
    OnboardingModel(
      title: 'Rate, Review, and Learn',
      supTitle:
          "Share your thoughts on the movies\n you've watched. Dive deep into film\n details and help others discover great\n movies with your reviews.",
      imagePath: 'assets/images/movie_poster_known.jpg',
      textBttn: 'Next',
      secondTextBttn: 'Back',
      layout: OnboardingLayout.bottomSheet,
    ),
    OnboardingModel(
      title: 'Start Watching Now',
      imagePath: 'assets/images/movie_poster_sam.jpg',
      textBttn: 'Finish',
      secondTextBttn: 'Back',
      layout: OnboardingLayout.bottomSheet,
    ),
  ];
}
