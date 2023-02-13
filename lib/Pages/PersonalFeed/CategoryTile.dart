import 'dart:developer';

import 'package:blog_app/Model/SubscribedCategory.dart';
import 'package:blog_app/Pages/PersonalFeed/FeedArticlesPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryTile extends StatefulWidget {
  SubscribedCategory subscribedCategory;
  CategoryTile({required this.subscribedCategory});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  // SharedPreferences _sharedPreferences;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: InkWell(
            onTap: () {
              log('Opening category ${widget.subscribedCategory.categoryName} ');
              Get.to(
                  () => FeedArticlesPage(category: widget.subscribedCategory));
            },
            child: Material(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 219, 139, 49),
                ),
                alignment: Alignment.center,
                child: LayoutBuilder(
                  builder: (context, size) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: size.maxHeight * 0.7,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  20,
                                ),
                                topRight: Radius.circular(
                                  20,
                                ),
                              ),
                              color: Color.fromARGB(255, 237, 147, 44),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                  20,
                                ),
                                topRight: Radius.circular(
                                  20,
                                ),
                              ),
                              child: Image.asset(
                                'images/category_default.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          height: size.maxHeight * 0.3,
                          child: Text(
                            '${widget.subscribedCategory.categoryName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
