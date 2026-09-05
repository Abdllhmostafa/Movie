import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_button_widget.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
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
                          image: AssetImage('assets/images/docStrange_img.png'),
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
                            // AppColors.background.withValues(alpha: 0.8),
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width*.04),
                child: Column(
                  spacing: height * 0.02,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      spacing: height*.18,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back,)),
                            IconButton(onPressed: () {}, icon: Icon(Icons.favorite,))
                          ],
                        ),
                        InkWell(
                          child: CircleAvatar(
                            radius: width*.12,
                            backgroundColor: AppColors.primary,
                            child: CircleAvatar(
                              radius: width*.105,
                              backgroundColor: AppColors.white,
                              child: CircleAvatar(
                                radius: width*.08,
                                backgroundColor: AppColors.primary,
                                child: Icon(Icons.play_arrow_rounded,size: 42,color: AppColors.white,),
                              ),
                            ),
                          ),
                        ),
                        Text('Doctor Strange in the Multiverse of Madness',style: TextStyle(fontSize: 24,fontWeight: .bold,color: AppColors.white),textAlign: .center,)
                      ],
                    ),
                    Center(child: Text('2022',style: TextStyle(color: AppColors.movieYearColor,fontSize: 20,fontWeight: .bold),)),
                    AuthButtonWidget(backgroundColor: AppColors.btnBgColor,textColor: AppColors.white,text: 'Watch', onPressed: () {  },),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:  EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.inputFill.withValues(alpha: 0.71),
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.heart_broken_rounded, color: AppColors.gold, size: 26),
                              SizedBox(width: width * 0.04),
                              Text('15', style: TextStyle(color: AppColors.white, fontSize: 24,fontWeight: .bold),),
                            ],
                          ),
                        ),
                        Container(
                          padding:  EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.inputFill.withValues(alpha: 0.71),
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer, color: AppColors.gold, size: 26),
                              SizedBox(width: width * 0.04),
                              Text('90', style: TextStyle(color: AppColors.white, fontSize: 24,fontWeight: .bold),),
                            ],
                          ),
                        ),
                        Container(
                          padding:  EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.inputFill.withValues(alpha: 0.71),
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: AppColors.gold, size: 26),
                              SizedBox(width: width * 0.04),
                              Text('7.6', style: TextStyle(color: AppColors.white, fontSize: 24,fontWeight: .bold),),
                            ],
                          ),
                        ),

                      ],
                    ),
                    Text('ScreenShots',style: TextStyle(color: AppColors.white,fontSize: 24,fontWeight: .bold),),
                    Column(
                      spacing: height*.015,
                      children: [
                        Image.asset('assets/images/screenShot_img1.png'),
                        Image.asset('assets/images/screenShot_img2.png'),
                        Image.asset('assets/images/screenShot_img3.png'),
                      ],
                    ),
                    Text('Similar',style: TextStyle(color: AppColors.white,fontSize: 24,fontWeight: .bold),),
                    Column(
                      spacing: height*.015,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            _MoviePoster(width: width*.44,height: height*.3,imagePath: 'assets/images/movie1_img.png', rating: '7.7'),
                            _MoviePoster(width: width*.44,height: height*.3,imagePath: 'assets/images/movie2_img.png', rating: '7.7'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            _MoviePoster(width: width*.44,height: height*.3,imagePath: 'assets/images/movie3_img.png', rating: '7.7'),
                            _MoviePoster(width: width*.44,height: height*.3,imagePath: 'assets/images/docStrange_img.png', rating: '7.7'),
                          ],
                        ),
                      ],
                    ),
                    Text('Summary',style: TextStyle(color: AppColors.white,fontSize: 24,fontWeight: .bold),),
                    Text('''Following the events of Spider-Man No Way Home, Doctor Strange unwittingly casts a forbidden spell that accidentally opens up the multiverse. With help from Wong and Scarlet Witch, Strange confronts various versions of himself as well as teaming up with the young America Chavez while traveling through various realities and working to restore reality as he knows it. Along the way, Strange and his allies realize they must take on a powerful new adversary who seeks to take over the multiverse.—Blazer346''',style: TextStyle(color: AppColors.white,fontSize: 16),),
                    Text('Cast',style: TextStyle(color: AppColors.white,fontSize: 24,fontWeight: .bold),),
                    Column(
                      spacing: height*.01,
                      children: [
                        SizedBox(
                          height: height*0.1,
                          child: Container(
                            padding: EdgeInsets.all(width*.015),
                            decoration: BoxDecoration(
                              color:AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              spacing: width*.02,
                              children: [
                                SizedBox(
                                  height: height*0.08,
                                  width: width*0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset('assets/images/cast_img.png'),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .spaceEvenly,
                                  children: [
                                    Text('Name : Hayley Atwell',style: TextStyle(color: AppColors.white,fontSize: 20),),
                                    Text('Character : Captain Carter',style: TextStyle(color: AppColors.white,fontSize: 20),)
                                  ],
                                )
                              ],
                            ),
                          ),

                        ),
                        SizedBox(
                          height: height*0.1,
                          child: Container(
                            padding: EdgeInsets.all(width*.015),
                            decoration: BoxDecoration(
                              color:AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              spacing: width*.02,
                              children: [
                                SizedBox(
                                  height: height*0.08,
                                  width: width*0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset('assets/images/cast_img.png'),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .spaceEvenly,
                                  children: [
                                    Text('Name : Hayley Atwell',style: TextStyle(color: AppColors.white,fontSize: 20),),
                                    Text('Character : Captain Carter',style: TextStyle(color: AppColors.white,fontSize: 20),)
                                  ],
                                )
                              ],
                            ),
                          ),

                        ),
                        SizedBox(
                          height: height*0.1,
                          child: Container(
                            padding: EdgeInsets.all(width*.015),
                            decoration: BoxDecoration(
                              color:AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              spacing: width*.02,
                              children: [
                                SizedBox(
                                  height: height*0.08,
                                  width: width*0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset('assets/images/cast_img.png'),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .spaceEvenly,
                                  children: [
                                    Text('Name : Hayley Atwell',style: TextStyle(color: AppColors.white,fontSize: 20),),
                                    Text('Character : Captain Carter',style: TextStyle(color: AppColors.white,fontSize: 20),)
                                  ],
                                )
                              ],
                            ),
                          ),

                        ),
                        SizedBox(
                          height: height*0.1,
                          child: Container(
                            padding: EdgeInsets.all(width*.015),
                            decoration: BoxDecoration(
                              color:AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              spacing: width*.02,
                              children: [
                                SizedBox(
                                  height: height*0.08,
                                  width: width*0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset('assets/images/cast_img.png'),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .spaceEvenly,
                                  children: [
                                    Text('Name : Hayley Atwell',style: TextStyle(color: AppColors.white,fontSize: 20),),
                                    Text('Character : Captain Carter',style: TextStyle(color: AppColors.white,fontSize: 20),)
                                  ],
                                )
                              ],
                            ),
                          ),

                        ),
                      ],
                    ),
                    Text('Genres',style: TextStyle(color: AppColors.white,fontSize: 24,fontWeight: .bold),),
                    Column(
                      spacing: height*.01,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:  EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.surface,
                              ),
                              child: Text(
                                'Action',
                                style: TextStyle(color: AppColors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(width: width*.04,),
                            Container(
                              padding:  EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.surface,
                              ),
                              child: Text(
                                'Action',
                                style: TextStyle(color: AppColors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(width: width*.04,),
                            Container(
                              padding:  EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.surface,
                              ),
                              child: Text(
                                'Action',
                                style: TextStyle(color: AppColors.white, fontSize: 16),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding:  EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.surface,
                              ),
                              child: Text(
                                'Action',
                                style: TextStyle(color: AppColors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(width: width*.04,),
                            Container(
                              padding:  EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.surface,
                              ),
                              child: Text(
                                'Action',
                                style: TextStyle(color: AppColors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}

class _MoviePoster extends StatelessWidget {
  final String imagePath;
  final String rating;
  final double? width;
  final double? height;

  const _MoviePoster({
    required this.imagePath,
    required this.rating,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
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
