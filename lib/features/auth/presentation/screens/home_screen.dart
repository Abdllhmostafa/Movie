
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/bottom_Nav_Bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<String> movieImages = [
    'assets/images/movie1_img.png',
    'assets/images/movie2_img.png',
    'assets/images/movie3_img.png',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: height*0.69,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(movieImages[currentIndex]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withValues(alpha: 0.8),
                            AppColors.background,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/images/img_availableNow.png',width: width*.6,),
                      SizedBox(height: height * 0.01),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: height * 0.38,
                          initialPage: 0,
                          viewportFraction: 0.5,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          disableCenter: true,
                          animateToClosest: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        items: movieImages.map((imagePath) {
                          return _MoviePoster(
                            imagePath: imagePath,
                            rating: '7.7',
                          );
                        }).toList(),
                      ),
                      Image.asset('assets/images/img_watchNow.png',width: width*.8,),
                    ],
                  ),

                  SizedBox(height: height * 0.03),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Action',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'See More →',
                          style: TextStyle(color: AppColors.primary, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
              
                  SizedBox(height: height * 0.01),
              
                  SizedBox(
                    height: height * 0.28,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: width * 0.03),
                      itemBuilder: (context, index) {
                        return _MoviePoster(
                          imagePath: 'assets/images/movie1_img.png',
                          rating: '7.7',
                          width: width * 0.35,
                        );
                      },
                    ),
                  ),
              
                  SizedBox(height: height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:  SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width*.02),
        child: BottomNavBar(),
      )),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final String imagePath;
  final String rating;
  final double? width;

  const _MoviePoster({
    required this.imagePath,
    required this.rating,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          SizedBox(
            width: width,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.background.withValues(alpha: 0.71),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rating,
                    style: TextStyle(color: AppColors.white, fontSize: 12),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.star, color: AppColors.gold, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
