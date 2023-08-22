import 'dart:developer';

import 'package:blog_app/Model/Category.dart';
import 'package:blog_app/Model/Post2.dart' as posts;
import 'package:blog_app/Pages/Explore/ExploreViewArticle.dart';
import 'package:blog_app/Service/PostService.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/Widgets/DataLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArticlesPage extends StatefulWidget {
  ArticlesPage({required this.category});
  Category category;

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  SharedPreferences? _sharedPreferences;
  final PostService _postService = PostService();
  late Future<Map<String, dynamic>> _futurePosts;
  late int _totalPages;
  int _currentPage = 0;
  RefreshController _refreshController =
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
                SliverToBoxAdapter(
                  child: Column(children: [
                    Stack(
                      children: [
                        Container(
                          decoration: categoryTopDecoration,
                          padding: const EdgeInsets.only(
                            left: 2,
                            right: 2,
                            bottom: 20,
                          ),
                          alignment: Alignment.bottomLeft,
                          height: height * 0.4,
                          child: ListTile(
                            title: Text(
                              '${widget.category.categoryName}',
                              style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900]),
                            ),
                            subtitle: Text(
                              '${widget.category.categoryDescription}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 10,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                right: 4,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(
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
                                  ? const Text('Subscribed')
                                  : const Text('Subscribe')),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                  ]),
                ),
                FutureBuilder(
                    future: _futurePosts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _totalPages = snapshot.data!['totalPages'];
                        _currentPage = snapshot.data!['pageNumber'];
                        if (_posts.length == 0)
                          _posts = snapshot.data!['posts'];
                        log("Posts assigned");
                        return _posts.isNotEmpty
                            ? SliverToBoxAdapter(
                                child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 2,
                                          top: 2,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => ExploreViewArticle(
                                                  post: _posts[index],
                                                  sharedPreferences:
                                                      _sharedPreferences!),
                                              transition: Transition.downToUp,
                                              duration: const Duration(
                                                milliseconds: 800,
                                              ),
                                            );
                                          },
                                          child: ListTile(
                                            leading: SizedBox(
                                              child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://imagedbspringboot.blob.core.windows.net/imagecontainer/${_posts[index].image}',
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                          const DataLoadingIndicator(),
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
                                                Text('${_posts[index].title}'),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Container(
                                        height: 0.5,
                                        color: Colors.black,
                                      );
                                    },
                                    itemCount: _posts.length),
                              )
                            : SliverToBoxAdapter(
                                child: Center(
                                  child: Text(
                                    'No Data',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              );
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
