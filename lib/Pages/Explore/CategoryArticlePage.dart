import 'package:blog_app/Model/Category.dart';
import 'package:blog_app/Model/Post2.dart' as posts;
import 'package:blog_app/Pages/Explore/ExploreViewArticle.dart';
import 'package:blog_app/Service/PostService.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/DataLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CategoryArticlePage extends StatefulWidget {
  CategoryArticlePage({required this.category});
  Category category;

  @override
  State<CategoryArticlePage> createState() => _CategoryArticlePageState();
}

class _CategoryArticlePageState extends State<CategoryArticlePage> {
  SharedPreferences? _sharedPreferences;
  final PostService _postService = PostService();
  List<posts.Post2>? _posts;
  Future<void>? _loadData;
  @override
  void initState() {
    _loadData = _loadArticles();
  }

  Future<void> _loadArticles() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _posts = await _postService.getAllPostsForCategory(
        token: _sharedPreferences!.getString(BEARER_TOKEN)!,
        categoryid: widget.category.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        // _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: ((context, categoryProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await _loadArticles();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: categoryTopDecoration,
                          padding: EdgeInsets.only(
                            left: 2,
                            right: 2,
                            bottom: 2,
                          ),
                          alignment: Alignment.bottomLeft,
                          height: height * 0.4,
                          child: ListTile(
                            title: Text(
                              '${widget.category.categoryName}',
                              style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${widget.category.categoryDescription}',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 4,
                            ),
                            child: OutlinedButton(
                              onPressed: () async {
                                if (categoryProvider.subscribedCategoriesIDs
                                    .contains(widget.category.categoryId)) {
                                  bool result = await categoryProvider
                                      .unsubscribeFromCategory(
                                          token: _sharedPreferences!
                                              .getString(BEARER_TOKEN)!,
                                          userid: _sharedPreferences!
                                              .getInt(USER_ID)!,
                                          categoryid:
                                              widget.category.categoryId);
                                } else {
                                  bool result = await categoryProvider
                                      .subscribeToCategory(
                                          token: _sharedPreferences!
                                              .getString(BEARER_TOKEN)!,
                                          userid: _sharedPreferences!
                                              .getInt(USER_ID)!,
                                          categoryid:
                                              widget.category.categoryId);
                                }
                              },
                              child: (categoryProvider.subscribedCategoriesIDs
                                      .contains(widget.category.categoryId)
                                  ? Text('Subscribed')
                                  : Text('Subscribe')),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    FutureBuilder(
                      future: _loadData,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                          case ConnectionState.active:
                            {
                              return Center(
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  child: DataLoadingIndicator(),
                                ),
                              );
                            }
                          case ConnectionState.done:
                            {
                              if (_posts != null && _posts!.isNotEmpty) {
                                return ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 2,
                                          top: 2,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(() => ExploreViewArticle(
                                                post: _posts![index],
                                                sharedPreferences:
                                                    _sharedPreferences!));
                                          },
                                          child: ListTile(
                                            leading: SizedBox(
                                              child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://imagedbspringboot.blob.core.windows.net/imagecontainer/${_posts![index].image}',
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                          DataLoadingIndicator(),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          'images/category_default.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            title:
                                                Text('${_posts![index].title}'),
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
                                    itemCount: _posts!.length);
                              } else {
                                return Center(
                                  child: Text('No Data'),
                                );
                              }
                            }
                        }
                      },
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
}
