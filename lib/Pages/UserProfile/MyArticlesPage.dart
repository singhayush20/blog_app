import 'dart:developer';

import 'package:blog_app/GetController/ImageController.dart';
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
                                        child: ListTile(
                                          title: Text(
                                            postController
                                                .userArticles[index].title,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            postController
                                                .userArticles[index].content,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: PopupMenuButton(
                                            color: Colors.blueAccent,
                                            // add icon, by default "3 dot" icon
                                            // icon: Icon(Icons.book)
                                            itemBuilder: (context) {
                                              return [
                                                const PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                const PopupMenuItem<int>(
                                                  value: 1,
                                                  child: Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
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
                                                        postid: postController
                                                            .userArticles[index]
                                                            .postId);
                                                if (result[CODE] == '2000') {
                                                  // await _reloadUserArticles();
                                                  await _loadUserArticles(
                                                      postController);
                                                  context.loaderOverlay.hide();
                                                  Get.snackbar(
                                                    "Success!",
                                                    "Article deleted successfully!",
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    snackStyle:
                                                        SnackStyle.FLOATING,
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
                                                        SnackPosition.BOTTOM,
                                                    snackStyle:
                                                        SnackStyle.FLOATING,
                                                    colorText:
                                                        snackbarColorText,
                                                    backgroundColor:
                                                        snackbarBackgroundColor,
                                                  );
                                                }
                                              } else if (value == 1) {
                                                Get.to(
                                                  () => UpdateArticlePage(
                                                      post: postController
                                                          .userArticles[index],
                                                      token: _sharedPreferences!
                                                              .getString(
                                                                  BEARER_TOKEN) ??
                                                          'null',
                                                      userid:
                                                          _sharedPreferences!
                                                              .getInt(
                                                                  USER_ID)!),
                                                  transition:
                                                      Transition.leftToRight,
                                                  duration: const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                );
                                              }
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.bars,
                                              color: Colors.yellow,
                                              size: 15.sp,
                                            ),
                                          ),
                                          leading: Text(
                                            '${index + 1}.',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.white,
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
                                      color: Colors.white,
                                    );
                                  }),
                                  itemCount:
                                      postController.userArticles.length),
                            ),
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
