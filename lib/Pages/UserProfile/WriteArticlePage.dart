import 'dart:developer';
import 'dart:io';

import 'package:blog_app/Model/Category.dart';
import 'package:blog_app/GetController/ImageController.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/constants/Widgets/PostTextField.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class WriteArticlePage extends StatefulWidget {
  const WriteArticlePage({super.key});

  @override
  State<WriteArticlePage> createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  final AppBar _appBar = AppBar(
    title: const Text('Write a new Article'),
  );
  SharedPreferences? _sharedPreferences;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Category? _selectedCategory;
  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  void _initializePrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    log('Shared Pref set');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    //Inject image controller
    Get.lazyPut(() => ImageController());
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        kBottomNavigationBarHeight;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar,
      body: GetBuilder<ImageController>(
        builder: (imageController) {
          return LoaderOverlay(
            overlayWidget: Center(
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                child: const Center(
                  child: LoadingIndicator(
                    strokeWidth: 0.5,
                    indicatorType: Indicator.ballPulse,
                    colors: customIndicatorColors,
                  ),
                ),
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                ),
                child: Column(
                  children: [
                    Container(
                      height: height * 0.05,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Choose a category',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFF006697),
                      ),
                      child: DropdownButton<Category>(
                        value: _selectedCategory,
                        hint: const Text(
                          'Select Category',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        items: categoryProvider.allCategories!
                            .map<DropdownMenuItem<Category>>((Category value) {
                          return DropdownMenuItem<Category>(
                            value: value,
                            child: Text(
                              value.categoryName,
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        isExpanded:
                            true, //make true to take width of parent widget
                        underline: Container(), //empty line
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                        dropdownColor: const Color(0xFF97B1C5),
                        iconEnabledColor: Colors.black,
                        menuMaxHeight: 100,
                        //Icon color
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                      ),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: imageController.pickedFile != null
                          ? Image.file(
                              File(imageController.pickedFile!.path),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              margin: const EdgeInsets.only(
                                top: 4,
                              ),
                              height: height * 0.3,
                              child: Image.asset(
                                'images/pick_file.jpg',
                              ),
                            ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        child: Text(
                          'Select an Image',
                          style: TextStyle(
                            fontSize: 15.sp,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          imageController.pickImage();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                      ),
                      child: PostTextField(
                        textController: _titleController,
                        hintText: "Enter your title here...",
                        labelText: "Title",
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                      ),
                      child: PostTextField(
                        textController: _contentController,
                        hintText: "Enter your content here...",
                        labelText: "Content",
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ElevatedButton(
                      onPressed: (_sharedPreferences != null)
                          ? () async {
                              final api = API();
                              if (imageController.pickedFile == null ||
                                  _selectedCategory == null) {
                                Get.snackbar(
                                  'Image/Category required!',
                                  "Choose image and category",
                                  snackPosition: SnackPosition.BOTTOM,
                                  snackStyle: SnackStyle.FLOATING,
                                  colorText: snackbarColorText,
                                  backgroundColor: snackbarBackgroundColor,
                                );
                                return;
                              }
                              if (_titleController.text.trim().isEmpty ||
                                  _contentController.text.trim().isEmpty) {
                                Get.snackbar(
                                  'Empty Fields',
                                  "Please provide Title and Content!",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  colorText: snackbarColorText,
                                  backgroundColor: snackbarBackgroundColor,
                                );
                                return;
                              }
                              context.loaderOverlay.show();

                              Map<String, dynamic> postResult = await api
                                  .createPost(
                                      userid:
                                          _sharedPreferences!.getInt(USER_ID)!,
                                      categoryid: _selectedCategory!.categoryId,
                                      token: _sharedPreferences!
                                          .getString(BEARER_TOKEN)!,
                                      post: {
                                    "title": _titleController.text,
                                    "content": _contentController.text
                                  });
                              if (postResult[CODE] == '2000' &&
                                  imageController.pickedFile != null) {
                                bool result = await imageController.uploadImage(
                                    postid: postResult['data']['postId'],
                                    token: _sharedPreferences!
                                        .getString(BEARER_TOKEN)!,
                                    isUpdatingPost: false);

                                if (result) {
                                  Get.snackbar(
                                    'Success',
                                    'Post created successfully!',
                                    snackPosition: SnackPosition.BOTTOM,
                                    snackStyle: SnackStyle.FLOATING,
                                    colorText: snackbarColorText,
                                    backgroundColor: snackbarBackgroundColor,
                                  );
                                  context.loaderOverlay.hide();
                                  log('Going back from write article page');

                                  Get.back();
                                }
                              } else if (postResult[CODE] == '2000') {
                                Get.snackbar(
                                  'Success',
                                  'Post created successfully!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  snackStyle: SnackStyle.FLOATING,
                                  colorText: snackbarColorText,
                                  backgroundColor: snackbarBackgroundColor,
                                );
                                context.loaderOverlay.hide();
                                log('Going back from write article page');
                                Get.back();
                              } else {
                                Get.snackbar(
                                  'Failure',
                                  'Post not created!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  snackStyle: SnackStyle.FLOATING,
                                  colorText: snackbarColorText,
                                  backgroundColor: snackbarBackgroundColor,
                                );
                                context.loaderOverlay.hide();
                              }
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Text(
                          'Save post',
                          style: TextStyle(
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
