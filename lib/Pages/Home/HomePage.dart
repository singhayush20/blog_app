import 'package:blog_app/Pages/ExplorePage.dart';
import 'package:blog_app/Pages/PersonalFeedPage.dart';
import 'package:blog_app/Pages/ProfilePage.dart';
import 'package:blog_app/Pages/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    PersonalFeedPage(),
    ExplorePage(),
    ProfilePage(),
    SettingsPage(),
  ];
  late PageController _pageController;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _pages,
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTapped,
        items: [
          const BottomNavigationBarItem(
            label: "Feed",
            icon: Icon(FontAwesomeIcons.rss),
          ),
          const BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(FontAwesomeIcons.borderAll),
          ),
          const BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(FontAwesomeIcons.user),
          ),
          const BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(FontAwesomeIcons.gears),
          ),
        ],
      ),
    );
  }
}
