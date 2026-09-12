import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';

class SearchTab extends StatelessWidget {
  final bool showBottomNav;
  const SearchTab({super.key, this.showBottomNav = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: AppColors.white, fontSize: 16),
                  fillColor: AppColors.inputFill,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Image.asset(
                  'assets/images/search_icn.png',
                  width: width * 0.35,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .02),
                child: const BottomNavBar(),
              ),
            )
          : null,
    );
  }
}
