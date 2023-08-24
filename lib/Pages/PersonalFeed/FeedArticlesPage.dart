import 'dart:developer';

import 'package:blog_app/Model/Post2.dart' as posts;
import 'package:blog_app/Model/SubscribedCategory.dart';
import 'package:blog_app/Pages/Explore/ExploreViewArticle.dart';
import 'package:blog_app/Service/PostService.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/Widgets/DataLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class FeedArticlesPage extends StatefulWidget {
  SubscribedCategory category;
  FeedArticlesPage({required this.category});

  @override
  State<FeedArticlesPage> createState() => _FeedArticlesPageState();
}

class _FeedArticlesPageState extends State<FeedArticlesPage> {
  SharedPreferences? _sharedPreferences;
  final PostService _postService = PostService();
  late Future<Map<String, dynamic>> _futurePosts;
  late int _totalPages;
  int _currentPage = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<posts.Post2> _posts = [];
  @override
  void initState() {
    super.initState();
    _futurePosts = getAllPosts(pageNumber: 0);
  }

  Future<Map<String, dynamic>> getAllPosts({required int pageNumber}) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _postService.getAllPostsForCategory(
        token: _sharedPreferences!.getString(BEARER_TOKEN)!,
        categoryid: widget.category.categoryId,
        pageKey: pageNumber,
        pageSize: PAGE_SIZE);
  }

  void _onRefresh() async {
    _futurePosts = _postService.getAllPostsForCategory(
        token: _sharedPreferences!.getString(BEARER_TOKEN)!,
        categoryid: widget.category.categoryId,
        pageKey: 0,
        pageSize: PAGE_SIZE);

    Future.wait([_futurePosts]).then((value) => setState(() {
          _posts = value[0]['posts'];
          _totalPages = value[0]['totalPages'];
          _currentPage = 0;
        }));

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void _onLoading() async {
    // monitor network fetch
    log("In _onLoading");

    if (_currentPage + 1 < _totalPages) {
      log("In currentpage+1 <total pages");
      _futurePosts = _postService.getAllPostsForCategory(
          token: _sharedPreferences!.getString(BEARER_TOKEN)!,
          categoryid: widget.category.categoryId,
          pageKey: _currentPage + 1,
          pageSize: PAGE_SIZE);
      Future.wait([_futurePosts]).then((value) => setState(() {
            _currentPage++;
            _posts.addAll(value[0]['posts']);
          }));
      log('Size of post=${_posts.length}');
      // if failed,use refreshFailed()
      _refreshController.loadComplete();
    } else {
      log("No More Data");
      setState(() {
        _refreshController.loadNoData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Consumer<CategoryProvider>(
          builder: ((context, categoryProvider, child) {
            return SmartRefresher(
              enablePullUp: true,
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              header: const WaterDropMaterialHeader(
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
              footer: CustomFooter(
                builder: (context, mode) {
                  Widget body;
                  log("Mode is $mode");
                  if (mode == LoadStatus.idle) {
                    body = const Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = const CircularProgressIndicator.adaptive();
                  } else if (mode == LoadStatus.failed) {
                    body = const Text("Load Failed! Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = const Text("release to load more");
                  } else {
                    body = const Text("---");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              child: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: height * 0.1,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      widget.category.categoryName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: _futurePosts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _totalPages = snapshot.data!['totalPages'];
                        _currentPage = snapshot.data!['pageNumber'];
                        if (_posts.isEmpty) {
                          _posts = snapshot.data!['posts'];
                        }
                        log("Posts assigned");
                        return _posts.isNotEmpty
                            ? SliverToBoxAdapter(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _posts
                                      .length, // Replace with your post list length
                                  itemBuilder: (context, index) {
                                    final post = _posts[
                                        index]; // Replace with your post model

                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => ExploreViewArticle(
                                            post: _posts[index],
                                            sharedPreferences:
                                                _sharedPreferences!));
                                      },
                                      child: Card(
                                        elevation: 6,
                                        shadowColor: Colors.black87,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://blogimagesa.blob.core.windows.net/imagecontainer/${post.image}',
                                                height:
                                                    200, // Adjust the image height as needed
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  child: Image.asset(
                                                      'images/placeholder_image.jpg'),
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        'images/placeholder_image.jpg'),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    post.title,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    post.content,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 218, 138, 32),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SliverToBoxAdapter(
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
                              ));
                      } else {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: const CustomLoadingIndicator(),
                            ),
                          ),
                        );
                      }
                    })
              ]),
            );
          }),
        ),
      ),
    );
  }
}
