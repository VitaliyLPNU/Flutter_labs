import 'package:flutter/material.dart';
import 'package:lab2/config/responsive_config.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: ResponsiveConfig.iconSize(context)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.fitness_center,
            size: ResponsiveConfig.iconSize(context),
          ),
          label: 'Training',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: ResponsiveConfig.iconSize(context)),
          label: 'Me',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 17, 68, 221),
      onTap: onItemTapped,
    );
  }
}
