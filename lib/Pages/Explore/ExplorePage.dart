import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:blog_app/Pages/Explore/ArticlesPage.dart';
import 'package:blog_app/provider/CategoryProvider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final _appBar = AppBar(
    title: const Text('Explore'),
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final categoryProvider = context.watch<CategoryProvider>();
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        kBottomNavigationBarHeight;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _appBar,
      body: SafeArea(
        child: RefreshIndicator(
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
                SizedBox(height: height * 0.02),
                (categoryProvider.allCategories == null ||
                        categoryProvider.allCategories!.length == 0)
                    ? Container(
                        child: Center(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: height * 0.3,
                                  width: width * 0.9,
                                  child: Center(
                                    child: Image.asset(
                                      "images/no_data_image.jpg",
                                      fit: BoxFit.cover,
                                    ), // Replace with your actual image
                                  ),
                                ),
                                SizedBox(height: height * 0.05),
                                const Text(
                                  'No Articles found!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Sorry, there are no articles available at the moment.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: categoryProvider.allCategories!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => ArticlesPage(
                                  category:
                                      categoryProvider.allCategories![index],
                                ),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}.',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    categoryProvider
                                        .allCategories![index].categoryName,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
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
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
