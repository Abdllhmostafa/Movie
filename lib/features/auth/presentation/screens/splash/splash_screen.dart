import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/routes/app_routers.dart';
import 'package:movie_app/core/routes/route_name.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: FadeInDown(
                  onFinish:(_){
                    Navigator.pushReplacementNamed(context,RouteName.onBoarding);
                  },
                  animate: true,
                  delay: Duration(seconds: 2),
                  child: Image.asset(
                    'assets/logos/logo_app.png',
                    width: 121.w,
                    height: 118.h,
                  ),
                ),
              ),
            ),
            FadeInUp(
              animate: true,
              delay: Duration(seconds: 2),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logos/footer_splash.png',
                    width: 180.w,
                    height: 76.h,
                  ),
                  Image.asset(
                    'assets/logos/footer_splash1.png',
                    width: 244.w,
                    height: 38.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
