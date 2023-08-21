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
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: height * 0.1,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${DateFormat("EEEEE, dd, yyyy").format(DateTime.now())}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 25.sp),
                                ),
                              ),
                              (categoryProvider.subscribedCategories != null &&
                                      categoryProvider
                                          .subscribedCategories.isNotEmpty)
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
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
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
          },
        ));
  }
}
