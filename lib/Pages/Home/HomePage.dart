import 'dart:developer';

import 'package:blog_app/Pages/Explore/ExplorePage.dart';
import 'package:blog_app/Pages/PersonalFeed/PersnalFeed.dart';
import 'package:blog_app/Pages/Settings/SettingsPage.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:blog_app/Pages/UserProfile/ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    PersonalFeed(),
    ExplorePage(),
    ProfilePage(),
    SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _items = [
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
      log("Bottom Navigation: fetching all categories");
      categoryProvider.fetchAllCategories();
    }
    return Scaffold(
      body: (!(categoryProvider.loadingStatus == LoadingStatus.LOADING ||
              categoryProvider.loadingStatus == LoadingStatus.NOT_STARTED))
          /*
      Wrap PageView in GetBuilder and fetch the subscribed categories
      If the subscribed categories list is not empty then ask the user to subscribe
      by presenting a list else direct to the PageView
       */
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
                  items: _items,
                )
              : null,
    );
  }
}
