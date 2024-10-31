import 'package:flutter/material.dart';
import 'package:lab2/config/responsive_config.dart';
import 'package:lab2/pages/training_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

List<Widget> pagesList(BuildContext context) {
  final contentFontSize = ResponsiveConfig.contentFontSize(context);

  return [
    Center(
      child: Text('Home', style: TextStyle(fontSize: contentFontSize)),
    ),
     const TrainingPage(),
    const UserProfileContent(), // Переносимо контент для "Me" у новий віджет
  ];
}

class UserProfileContent extends StatelessWidget {
  const UserProfileContent({super.key});

  Future<Map<String, String>> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? 'Unknown';
    final email = prefs.getString('loggedInUserEmail') ?? 'Unknown';
    return {'name': name, 'email': email};
  }

  @override
  Widget build(BuildContext context) {
    final avatarRadius = ResponsiveConfig.avatarRadius(context);
    final spacing = ResponsiveConfig.spacing(context);
    final fontSizeName = ResponsiveConfig.fontSizeName(context);
    final fontSizeEmail = ResponsiveConfig.fontSizeEmail(context);

    return FutureBuilder<Map<String, String>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No profile data available'));
        } else {
          final userData = snapshot.data!;
          return Column(
            children: [
              AppBar(
                title: const Text('Me'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: const AssetImage('assets/place_holder.jpg'),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        'Name: ${userData['name']}',
                        style: TextStyle(
                          fontSize: fontSizeName,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spacing / 2),
                      Text(
                        'Email: ${userData['email']}',
                        style: TextStyle(
                          fontSize: fontSizeEmail,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
