import 'package:eloit/screens/category_page.dart';
import 'package:eloit/screens/search_page.dart';
import 'package:eloit/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String APP_NAME = 'Eloit';

const Color COLOR_BACKGROUND = Color(0xFF000452);
const Color COLOR_OBJECTS = Color(0xFF00FF04);
const Color COLOR_CONTRAST_BACKGROUND = Colors.white;
const Color COLOR_FLOATING_TEXT = Colors.white;
const Color COLOR_CONFINED_TEXT = Colors.black;
const Color COLOR_FLOATING_LINK_TEXT = Colors.yellow;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const CategoryPage(),
    const SearchPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        title: const Text('$APP_NAME. Logged in'),
        actions: [
          ElevatedButton(
            child: const Text('Log out'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Now navigate to the auth page.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthBox(),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}


