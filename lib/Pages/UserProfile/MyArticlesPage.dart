import 'dart:developer';

import 'package:blog_app/GetController/ImageController.dart';
import 'package:blog_app/Pages/Explore/ExploreViewArticle.dart';
import 'package:blog_app/Pages/UserProfile/UpdateArticlePage.dart';
import 'package:blog_app/Pages/UserProfile/ViewArticle.dart';
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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void>? _initialData;
  Future<void> _loadUserArticles(ImageController postController) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await postController.loadUserArticles(
        token: _sharedPreferences!.getString(BEARER_TOKEN)!,
        userid: _sharedPreferences!.getInt(USER_ID)!);
  }

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  void _initializePrefs() async {
    _api = API();
    Get.lazyPut(() => ImageController());
  }

  final AppBar _appBar = AppBar(
    title: const Text("Your Articles"),
  );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    log('Building MyArticles Page!');
    return Scaffold(
      appBar: _appBar,
      body: GetBuilder<ImageController>(
        builder: (postController) {
          _initialData ??= _loadUserArticles(postController);
          return FutureBuilder(
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
                    if (postController.userArticles.isNotEmpty) {
                      return LoaderOverlay(
                        overlayWidget: Container(
                          height: 100,
                          width: 100,
                          child: const CustomLoadingIndicator(),
                        ),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await postController.loadUserArticles(
                                token: _sharedPreferences!
                                        .getString(BEARER_TOKEN) ??
                                    'null',
                                userid:
                                    _sharedPreferences!.getInt(USER_ID) ?? 0);
                          },
                          key: _refreshIndicatorKey,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                ),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: postController.userArticles.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02,
                                      ),
                                      child: Card(
                                        elevation: 6,
                                        shadowColor: Colors.grey,
                                        margin: EdgeInsets.symmetric(
                                            vertical: height * 0.01),
                                        color: (index % 2 == 0)
                                            ? Color.fromARGB(255, 188, 228, 248)
                                            : Color.fromARGB(255, 144, 240,
                                                148), // Adding a background color
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                              ViewArticle(
                                                  post: postController
                                                      .userArticles[index],
                                                  sharedPreferences:
                                                      _sharedPreferences!),
                                              transition: Transition.topLevel,
                                              duration: const Duration(
                                                milliseconds: 1000,
                                              ),
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  postController
                                                      .userArticles[index]
                                                      .title,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 85, 21, 96),
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceAround, // Aligns menu to the right
                                                children: [
                                                  Expanded(
                                                    flex: 6,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            width * 0.02,
                                                      ),
                                                      child: Text(
                                                        postController
                                                            .userArticles[index]
                                                            .content,
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: Color.fromARGB(
                                                              255, 87, 56, 9),
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: PopupMenuButton(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 172, 203, 255),
                                                        itemBuilder: (context) {
                                                          return [
                                                            const PopupMenuItem<
                                                                int>(
                                                              value: 0,
                                                              child: Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            const PopupMenuItem<
                                                                int>(
                                                              value: 1,
                                                              child: Text(
                                                                "Update",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected:
                                                            (value) async {
                                                          if (value == 0) {
                                                            context
                                                                .loaderOverlay
                                                                .show();
                                                            Map<String, dynamic>
                                                                result =
                                                                await _api.deletePost(
                                                                    token: _sharedPreferences!.getString(
                                                                            BEARER_TOKEN) ??
                                                                        'null',
                                                                    postid: postController
                                                                        .userArticles[
                                                                            index]
                                                                        .postId);
                                                            if (result[CODE] ==
                                                                '2000') {
                                                              // await _reloadUserArticles();
                                                              await _loadUserArticles(
                                                                  postController);
                                                              context
                                                                  .loaderOverlay
                                                                  .hide();
                                                              Get.snackbar(
                                                                "Success!",
                                                                "Article deleted successfully!",
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                snackStyle:
                                                                    SnackStyle
                                                                        .FLOATING,
                                                                colorText:
                                                                    snackbarColorText,
                                                                backgroundColor:
                                                                    snackbarBackgroundColor,
                                                              );
                                                            } else {
                                                              Get.snackbar(
                                                                "Failed!",
                                                                "Failed to delete article!",
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                snackStyle:
                                                                    SnackStyle
                                                                        .FLOATING,
                                                                colorText:
                                                                    snackbarColorText,
                                                                backgroundColor:
                                                                    snackbarBackgroundColor,
                                                              );
                                                            }
                                                          } else if (value ==
                                                              1) {
                                                            Get.to(
                                                              () => UpdateArticlePage(
                                                                  post: postController
                                                                          .userArticles[
                                                                      index],
                                                                  token: _sharedPreferences!
                                                                          .getString(
                                                                              BEARER_TOKEN) ??
                                                                      'null',
                                                                  userid: _sharedPreferences!
                                                                      .getInt(
                                                                          USER_ID)!),
                                                              transition:
                                                                  Transition
                                                                      .leftToRight,
                                                              duration:
                                                                  const Duration(
                                                                milliseconds:
                                                                    200,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .ellipsisV, // Three dots icon
                                                          color: Colors.black,
                                                          size: 15.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ),
                        ),
                      );
                    } else {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: height * 0.4,
                                child: Image.asset('images/no_data_image.jpg')),
                            Container(
                              height: height * 0.1,
                              alignment: Alignment.center,
                              child: Text(
                                'No Data',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              height: height * 0.1,
                              child: TextButton(
                                onPressed: () async {
                                  await postController.loadUserArticles(
                                      token: _sharedPreferences!
                                              .getString(BEARER_TOKEN) ??
                                          'null',
                                      userid:
                                          _sharedPreferences!.getInt(USER_ID) ??
                                              0);
                                },
                                child: Text(
                                  'Try Again',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ]);
                    }
                  }
              }
            },
          );
        },
      ),
    );
  }
}
