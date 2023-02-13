import 'dart:developer';

import 'package:blog_app/Pages/PersonalFeed/CategoryTile.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PersonalFeed extends StatefulWidget {
  const PersonalFeed({Key? key}) : super(key: key);

  @override
  State<PersonalFeed> createState() => _PersonalFeedState();
}

class _PersonalFeedState extends State<PersonalFeed> {
  List<Tab> _tabs = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _appBar = AppBar(
    title: Text('Feed'),
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
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.8,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Today,',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              (categoryProvider.subscribedCategories != null &&
                                      categoryProvider
                                          .subscribedCategories.isNotEmpty)
                                  ? GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
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
                      ),
                    ],
                  ),
                ),
              );
            } else
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
          },
        ));
  }

  List<Widget> _tabsList() {
    _tabs = [];
    // for (var category in subscribedCategories) {
    //   _tabs.add(Tab(text: category.categoryName));
    // }
    List<Tab> tabs = [];
    Tab fullFeedPage = const Tab(text: 'All');
    Tab personalized = const Tab(text: 'Subscribed');
    _tabs.add(fullFeedPage);
    _tabs.add(personalized);
    return _tabs;
  }
}

//  Container(
//                         height: height * 0.2,
//                         child: FloatingSearchBar(
//                           hint: 'Search...',
//                           scrollPadding:
//                               const EdgeInsets.only(top: 16, bottom: 56),
//                           transitionDuration: const Duration(milliseconds: 800),
//                           transitionCurve: Curves.easeInOut,
//                           physics: const BouncingScrollPhysics(),
//                           openAxisAlignment: 0.0,
//                           debounceDelay: const Duration(milliseconds: 500),
//                           onQueryChanged: (query) {
//                             if (query.trim().length > 5) {
//                               categoryProvider.searchForPosts(keyword: query);
//                             }
//                           },
//                           // Specify a custom transition to be used for
//                           // animating between opened and closed stated.
//                           transition: CircularFloatingSearchBarTransition(),
//                           actions: [
//                             FloatingSearchBarAction(
//                               showIfOpened: true,
//                               child: CircularButton(
//                                 icon: const Icon(Icons.search),
//                                 onPressed: () {
//                                   log('Search pressed');
//                                 },
//                               ),
//                             ),
//                             // FloatingSearchBarAction.searchToClear(
//                             //   showIfClosed: false,
//                             // ),
//                           ],
//                           builder: (context, transition) {
//                             return ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Material(
//                                 color: Colors.white,
//                                 elevation: 4.0,
//                                 child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: categoryProvider.searchedPosts),
//                               ),
//                             );
//                           },
//                         ),
//                       ),