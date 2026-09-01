import 'package:flutter/material.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/screens/onboarding/onBoarding_model.dart';
import 'package:movie_app/features/auth/presentation/widgets/onboarding_bottom_content.dart';
import '../../widgets/onboarding_normal_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < OnboardingModel.onBoardingList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, RouteName.login);
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,

        itemCount: OnboardingModel.onBoardingList.length,
        itemBuilder: (context, index) {
          final page = OnboardingModel.onBoardingList[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(page.imagePath, fit: BoxFit.cover),
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.textDark.withValues(alpha: 0.5),
                        AppColors.textDark.withValues(alpha: 0.7),
                        AppColors.textDark.withValues(alpha: 0.8),
                      ],
                      stops: [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              if (page.layout == OnboardingLayout.normal) ...[
                OnboardingNormalContent(onNext: _nextPage,page:page,)
              ] else ...[
                OnboardingBottomContent(page: page, onNext: _nextPage, onPrevious: _previousPage)
              ],
            ],
          );
        },
      ),
    );
  }
}
