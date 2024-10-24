import 'package:flutter/material.dart';

import 'package:lab2/elements/pages_list.dart';
import 'package:lab2/widgets/custom_bottom_navigation_bar.dart';
import 'package:lab2/widgets/custom_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void onItemTapped(
      BuildContext context,
      int index,
      void Function(int) updateIndex,
      ) {
    if (index < pagesList(context).length) {
      updateIndex(index);
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile').then((_) {
        updateIndex(0);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      onItemTapped(context, index, updateIndex);
    });
  }

  void updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout App')),
      drawer: const CustomDrawer(),
      body: Center(
        child: _selectedIndex < pagesList(context).length
            ? pagesList(context).elementAt(_selectedIndex)
            : Container(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
