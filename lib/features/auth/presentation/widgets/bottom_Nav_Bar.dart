import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(

      borderRadius: BorderRadius.circular(16),
      child: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'null'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'null'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'null'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'null'),
        ],
      ),
    );
  }
}
