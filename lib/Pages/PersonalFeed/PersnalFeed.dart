import 'dart:async';
import 'dart:developer';

import 'package:blog_app/Pages/PersonalFeed/CategoryTile.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PersonalFeed extends StatefulWidget {
  const PersonalFeed({Key? key}) : super(key: key);

  @override
  State<PersonalFeed> createState() => _PersonalFeedState();
}

class _PersonalFeedState extends State<PersonalFeed> {
  late DateTime _currentDateTime;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    _startTimerToUpdateDateTime(); // Start the timer
  }

  // Timer to update date and time every minute
  void _startTimerToUpdateDateTime() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      log('Timer cancelled!');
    }
    super.dispose();
  }

  final _appBar = AppBar(
    title: const Text('Feed'),
  );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        kBottomNavigationBarHeight;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: _appBar,
        body: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            if (categoryProvider.subscribedCategories == null ||
                categoryProvider.subscribedCategories.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  await categoryProvider.loadSubscribedCategories();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Welcome and Date Widget
                      Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back. Get started with your favourite topics.',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              DateFormat('EEEE, MMMM d')
                                  .format(_currentDateTime),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                        ),
                        height: height,
                        child: Column(
                          children: [
                            (categoryProvider.subscribedCategories != null &&
                                    categoryProvider
                                        .subscribedCategories.isNotEmpty)
                                ? Container(
                                    height: height * 0.75,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: categoryProvider
                                          .subscribedCategories.length,
                                      itemBuilder: (context, index) =>
                                          CategoryTile(
                                        subscribedCategory: categoryProvider
                                            .subscribedCategories[index],
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: width > 700 ? 4 : 2,
                                        // childAspectRatio: 5,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'You haven\'t subscribed to any topic yet',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'You haven\'t subscribed to any topic yet',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
          },
        ));
  }
}
