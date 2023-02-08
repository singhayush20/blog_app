import 'dart:developer';

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
  @override
  void initState() {
    super.initState();
    log('explore page init called');
  }

  @override
  void dispose() {
    log('explore page dispose called');
    super.dispose();
  }

// final _appBar=AppBar(
//         title: Text("Explore"),
//       );
  late List<Tab> _tabs;
  late final _categoryProvider;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = MediaQuery.of(context).size.height -
        // _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    log('explore page builidng');
    return Scaffold(
      // appBar: _appBar,
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: ((context, categoryProvider, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 10,
                      top: 10,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02,
                    ),
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Get.to
                            },
                            child: ListTile(
                              leading: Text(
                                '${index + 1}.',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                              title: Text(
                                categoryProvider
                                    .allCategories![index].categoryName,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                categoryProvider!
                                    .allCategories![index].categoryDescription,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black54,
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
                            color: Colors.black,
                          );
                        },
                        itemCount: categoryProvider.allCategories!.length),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
