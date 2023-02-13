import 'dart:developer';

import 'package:blog_app/GetController/SubscribedCategoriesController.dart';
import 'package:blog_app/Model/Post2.dart';
import 'package:blog_app/Service/PostService.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalFeedPage extends StatefulWidget {
  const PersonalFeedPage({super.key});

  @override
  State<PersonalFeedPage> createState() => _PersonalFeedPageState();
}

class _PersonalFeedPageState extends State<PersonalFeedPage>
    with AutomaticKeepAliveClientMixin {
  SharedPreferences? _sharedPreferences;
  Future<void>? _loadSubscribedCategories;
  @override
  void initState() {
    super.initState();
    log('Personal feed init called');
  }

  Future<void> _loadSubsCats(SubscribedCategoriesController controller) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    controller.loadSubscribedCategories(
        token: _sharedPreferences!.getString(BEARER_TOKEN)!,
        userid: _sharedPreferences!.getInt(USER_ID)!);
  }

  final PostService _postService = PostService();
  Future<void>? _loadArticlesInit;
  List<Post2> _posts = [];
  Future<void> _loadArticles(
      {required int categoryid, required String token}) async {
    // _posts = await _postService.getAllPostsForCategory(
    //     token: token, categoryid: categoryid, pageKey: );
    setState(() {});
  }

  final _appBar = AppBar(
    title: Text("Feed"),
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    log('Building Personal feed page');
    return Scaffold(
      appBar: _appBar,
      body:
          GetBuilder<SubscribedCategoriesController>(builder: (catController) {
        _loadSubscribedCategories ??= _loadSubsCats(catController);

        return FutureBuilder(
            future: _loadSubscribedCategories,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  {
                    log('In connection state none');
                    return Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: const CustomLoadingIndicator(),
                      ),
                    );
                  }
                case ConnectionState.waiting:
                  {
                    log('In connection state waiting');
                    return Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: const CustomLoadingIndicator(),
                      ),
                    );
                  }
                case ConnectionState.active:
                  {
                    log('In connection state waiting');
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
                    log('in connectionstate.done: ${catController.subscribedCategories.length}: ${catController.subscribedCategories.isNotEmpty}');
                    log('snapshot.hasData: ${snapshot.hasData}');
                    if (catController.subscribedCategories.isNotEmpty) {
                      _loadArticlesInit ??= _loadArticles(
                          categoryid:
                              catController.subscribedCategories[0].categoryId,
                          token: _sharedPreferences!.getString(BEARER_TOKEN)!);
                    }
                    return (catController.subscribedCategories.isNotEmpty)
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await _loadSubsCats(catController);
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: Container(
                                  height: height,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: height * 0.05,
                                      ),
                                      Container(
                                        height: height * 0.05,
                                        width: width,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          // shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: ElevatedButton(
                                                child: Text(
                                                    '${catController.subscribedCategories[index].categoryName}'),
                                                onPressed: () {},
                                              ),
                                            );
                                          },
                                          separatorBuilder: ((context, index) {
                                            return Container(
                                              height: height * 0.05,
                                              width: 2,
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 2,
                                              ),
                                              color: Colors.black,
                                            );
                                          }),
                                          itemCount: catController
                                              .subscribedCategories.length,
                                        ),
                                      ),
                                      FutureBuilder(
                                          future: _loadArticlesInit,
                                          builder: (context, snapshot2) {
                                            switch (snapshot2.connectionState) {
                                              case ConnectionState.none:
                                              case ConnectionState.waiting:
                                              case ConnectionState.active:
                                                {
                                                  return Center(
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      child:
                                                          const CustomLoadingIndicator(),
                                                    ),
                                                  );
                                                }
                                              case ConnectionState.done:
                                                {
                                                  return ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    // shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        title: Text(
                                                            _posts[index]
                                                                .title),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        ((context, index) {
                                                      return Container(
                                                        height: height * 0.05,
                                                        width: 2,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 2,
                                                        ),
                                                        color: Colors.black,
                                                      );
                                                    }),
                                                    itemCount: _posts.length,
                                                  );
                                                }
                                            }
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            height: height,
                            child: Text('Data not found'),
                          );
                  }
              }
            });
      }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
