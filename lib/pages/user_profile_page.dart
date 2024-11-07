import 'package:flutter/material.dart';
import 'package:lab2/config/responsive_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  Future<Map<String, String>> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? 'Unknown';
    final email = prefs.getString('userEmail') ?? 'Unknown';
    return {'name': name, 'email': email};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No profile data available'));
          } else {
            final userData = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: ResponsiveConfig.avatarRadius(context),
                      backgroundImage: const AssetImage('assets/place_holder.jpg'),
                    ),
                    SizedBox(height: ResponsiveConfig.spacing(context)),
                    Text(
                      'Name: ${userData['name']}',
                      style: TextStyle(
                        fontSize: ResponsiveConfig.fontSizeName(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ResponsiveConfig.spacing(context) / 2),
                    Text(
                      'Email: ${userData['email']}',
                      style: TextStyle(
                        fontSize: ResponsiveConfig.fontSizeEmail(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
