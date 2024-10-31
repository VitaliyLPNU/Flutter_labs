import 'package:flutter/material.dart';
import 'package:lab2/elements/pages_list.dart';
import 'package:lab2/widgets/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _selectedIndex < pagesList(context).length
            ? pagesList(context).elementAt(_selectedIndex)
            : Container(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/training'); // Додайте перехід на TrainingPage
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}
