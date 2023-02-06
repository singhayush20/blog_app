import 'dart:developer';

import 'package:blog_app/Pages/ExplorePage.dart';
import 'package:blog_app/Pages/PersonalFeedPage.dart';
import 'package:blog_app/Pages/ProfilePage.dart';
import 'package:blog_app/Pages/SettingsPage.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
    final categoryProvider = Provider.of<CategoryProvider>(context);
    if (categoryProvider.loadingStatus == LoadingStatus.NOT_STARTED) {
      // log('Bottom Navigation: loading user for email: ${userProvider.sharedPreferences!.getString(EMAIL)} ');
      log("Bottom Navigation: fetching all categories");
      categoryProvider.fetchAllCategories();
    }
    return Scaffold(
      body: (!(categoryProvider.loadingStatus == LoadingStatus.LOADING ||
              categoryProvider.loadingStatus == LoadingStatus.NOT_STARTED))
          ? PageView(
              children: _pages,
              controller: _pageController,
              onPageChanged: onPageChanged,
            )
          : Center(
              child: Container(
                height: 100,
                width: 100,
                child: CustomLoadingIndicator(),
              ),
            ),
      bottomNavigationBar:
          (!(categoryProvider.loadingStatus == LoadingStatus.LOADING ||
                  categoryProvider.loadingStatus == LoadingStatus.NOT_STARTED))
              ? BottomNavigationBar(
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
                )
              : null,
    );
  }
}
