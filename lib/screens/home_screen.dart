import 'package:flutter/material.dart';
import 'package:test_flutter/models/google_user.dart';
import 'package:test_flutter/providers/auth_provider.dart';
import 'package:test_flutter/screens/google_photo_screen.dart';
import 'package:test_flutter/screens/local_photo_screen.dart';
import 'package:test_flutter/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Future<PhotoClient>? _photoClientFuture;

  @override
  void initState() {
    super.initState();
    _photoClientFuture = _createPhotoClient();
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final accessToken = await AuthNotifier().getAccessToken();
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }

  Future<PhotoClient> _createPhotoClient() async {
    return PhotoClient(getAuthHeaders());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? FutureBuilder<PhotoClient>(
              future: _photoClientFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return GooglePhotosScreen(photoClient: snapshot.data!);
                }
              },
            )
          : _selectedIndex == 1
              ? const LocalPhotosScreen()
              : const ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Google Photos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Local Photos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
