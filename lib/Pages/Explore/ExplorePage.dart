import 'dart:developer';

import 'package:blog_app/Pages/Explore/ArticlesPage.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final _appBar = AppBar(
    title: const Text(
      'Explore',
    ),
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        kBottomNavigationBarHeight;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar,
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: ((context, categoryProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await categoryProvider.reloadAllCategories();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      height: height * 0.1,
                      margin: const EdgeInsets.only(
                        left: 10,
                        top: 10,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Find more interesting articles and subscribe/unsubscribe to topics',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.blueAccent,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                      ),
                      height: height * 0.85,
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ArticlesPage(
                                      category: categoryProvider
                                          .allCategories![index]),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: Text(
                                  '${index + 1}.',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 15.sp),
                                ),
                                title: Text(
                                  categoryProvider
                                      .allCategories![index].categoryName,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  categoryProvider.allCategories![index]
                                      .categoryDescription,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 2,
                              color: Colors.grey,
                            );
                          },
                          itemCount: categoryProvider.allCategories!.length),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
