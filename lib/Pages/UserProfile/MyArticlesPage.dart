import 'dart:developer';

import 'package:blog_app/Model/Post.dart';
import 'package:blog_app/Pages/UserProfile/ViewArticle.dart';
import 'package:blog_app/Service/PostService.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MyArticlesPage extends StatefulWidget {
  const MyArticlesPage({super.key});

  @override
  State<MyArticlesPage> createState() => _MyArticlesPageState();
}

class _MyArticlesPageState extends State<MyArticlesPage> {
  SharedPreferences? _sharedPreferences;
  late final API _api;
  late PostService _postService;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Post> _userArticles = [];
  late Future<void> _initialData;
  Future<void> _loadUserArticles() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    final result = await _postService.getAllPostsForUser(
        token: _sharedPreferences!.getString(BEARER_TOKEN)!,
        userid: _sharedPreferences!.getInt(USER_ID)!);
    setState(() {
      _userArticles = result;
    });
  }

  Future<void> _reloadUserArticles() async {
    final result = await _postService.getAllPostsForUser(
        token: _sharedPreferences!.getString(BEARER_TOKEN)!,
        userid: _sharedPreferences!.getInt(USER_ID)!);
    setState(() {
      _userArticles = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  void _initializePrefs() async {
    _api = API();
    _postService = PostService();
    _initialData = _loadUserArticles();
  }

  final AppBar _appBar = AppBar(
    title: const Text("Profile"),
  );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar,
      body: FutureBuilder(
        future: _initialData,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              {
                return Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: const CustomLoadingIndicator(),
                  ),
                );
              }
            case ConnectionState.done:
              {
                if (_userArticles.isNotEmpty) {
                  return LoaderOverlay(
                    overlayWidget: Container(
                      height: 100,
                      width: 100,
                      child: CustomLoadingIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh: _reloadUserArticles,
                      key: _refreshIndicatorKey,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                            ),
                            child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                    ),
                                    decoration: listTileDecoration,
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                          ViewArticle(
                                              post: _userArticles[index],
                                              sharedPreferences:
                                                  _sharedPreferences!),
                                          transition: Transition.topLevel,
                                          duration: Duration(
                                            milliseconds: 1000,
                                          ),
                                        );
                                      },
                                      child: ListTile(
                                        title: Text(
                                          _userArticles[index].title,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          _userArticles[index].content,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: PopupMenuButton(
                                          // add icon, by default "3 dot" icon
                                          // icon: Icon(Icons.book)
                                          itemBuilder: (context) {
                                            return [
                                              const PopupMenuItem<int>(
                                                value: 0,
                                                child: Text("Delete"),
                                              ),
                                              const PopupMenuItem<int>(
                                                value: 1,
                                                child: Text("Update"),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) async {
                                            if (value == 0) {
                                              context.loaderOverlay.show();
                                              Map<String, dynamic> result =
                                                  await _api.deletePost(
                                                      token: _sharedPreferences!
                                                              .getString(
                                                                  BEARER_TOKEN) ??
                                                          'null',
                                                      postid:
                                                          _userArticles[index]
                                                              .postId);
                                              if (result['code'] == '2000') {
                                                await _reloadUserArticles();
                                                context.loaderOverlay.hide();
                                                Get.snackbar(
                                                  "Success!",
                                                  "Article deleted successfully!",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                );
                                              } else {
                                                Get.snackbar(
                                                  "Failed!",
                                                  "Failed to delete article!",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                );
                                              }
                                            } else if (value == 1) {}
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.bars,
                                            color: Colors.black,
                                            size: 15.sp,
                                          ),
                                        ),
                                        leading: Text(
                                          '${index + 1}.',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: ((context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.3,
                                    ),
                                    height: 2,
                                    color: Colors.black,
                                  );
                                }),
                                itemCount: _userArticles.length)),
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: _reloadUserArticles,
                    key: _refreshIndicatorKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 100,
                              child:
                                  Image.asset('images/category_default.jpg')),
                          Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: Text(
                              'No Data',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ]),
                  );
                }
              }
          }
        },
      ),
    );
  }
}
