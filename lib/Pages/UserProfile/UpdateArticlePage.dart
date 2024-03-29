import 'dart:developer';
import 'dart:io';

import 'package:blog_app/GetController/ImageController.dart';
import 'package:blog_app/Model/Post.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/Widgets/DataLoadingIndicator.dart';
import 'package:blog_app/constants/Widgets/PhotoPreview.dart';
import 'package:blog_app/constants/Widgets/PostTextField.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';

class UpdateArticlePage extends StatefulWidget {
  Post post;
  String token;
  int userid;
  UpdateArticlePage(
      {required this.post, required this.token, required this.userid});

  @override
  State<UpdateArticlePage> createState() => _UpdateArticlePageState();
}

class _UpdateArticlePageState extends State<UpdateArticlePage> {
  final AppBar _appBar = AppBar(
    title: const Text('Update'),
  );
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _uploadButtonClicked = false;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        kBottomNavigationBarHeight;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: _appBar,
        body: GetBuilder<ImageController>(
          builder: (imageController) {
            return LoaderOverlay(
              overlayWidget: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  child: const CustomLoadingIndicator(),
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
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        height: height * 0.4,
                        width: width,
                        color:
                            Colors.white, // Use your desired background color
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: (_uploadButtonClicked == true)
                                  ? imageController.pickedFile != null
                                      ? Image.file(
                                          File(
                                              imageController.pickedFile!.path),
                                          fit: BoxFit.cover,
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: height * 0.2,
                                              child: Image.asset(
                                                'images/pick_file.jpg',
                                              ),
                                            ),
                                            Text(
                                              'Your image appears here',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.sp,
                                                color: Colors
                                                    .black, // Adjust text color
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: TextButton(
                                                child: Text(
                                                  'Select an Image',
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors
                                                        .blueAccent, // Adjust text color
                                                  ),
                                                ),
                                                onPressed: () {
                                                  imageController.pickImage();
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return PhotoPreview(
                                                  image: widget.post.image);
                                            },
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: 'imageHero',
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://blogimagesa.blob.core.windows.net/imagecontainer/${widget.post.image}',
                                          placeholder: (context, url) => Center(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child: Image.asset(
                                                'images/placeholder_image.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'images/placeholder_image.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _uploadButtonClicked =
                                        !_uploadButtonClicked;
                                  });
                                  if (_uploadButtonClicked == false) {
                                    imageController.removeImage();
                                  }
                                },
                                icon: Icon(
                                  (_uploadButtonClicked == true)
                                      ? FontAwesomeIcons.times // Use close icon
                                      : FontAwesomeIcons.upload,
                                  size: 15.sp,
                                  color: Colors.red, // Adjust icon color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 1, // Adjust the height of the divider
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Adjust title text color
                              ),
                            ),
                            SizedBox(height: height * 0.01), // Adjust spacing
                            PostTextField(
                              textController: _titleController,
                              hintText: "Enter your title here...",
                              labelText: "",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Content",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Adjust title text color
                              ),
                            ),
                            SizedBox(height: height * 0.01), // Adjust spacing
                            PostTextField(
                              textController: _contentController,
                              hintText: "Enter your content here...",
                              labelText: "",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await _updatePost(imageController);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Text(
                            'Update post',
                            style: TextStyle(
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _updatePost(ImageController imageController) async {
    context.loaderOverlay.show();
    final _api = API();
    Map<String, dynamic> postResult = await _api.updatePostContent(
        token: widget.token,
        content: _contentController.text,
        title: _titleController.text,
        postid: widget.post.postId);
    log('Updating photo: ${!(imageController.pickedFile == null)}');
    if (postResult[CODE] == '2000' && imageController.pickedFile != null) {
      bool result = await imageController.uploadImage(
          postid: postResult['data']['postId'],
          token: widget.token,
          isUpdatingPost: true);
      if (result) {
        Get.snackbar(
          'Success',
          'Post updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          colorText: snackbarColorText,
          backgroundColor: snackbarBackgroundColor,
        );
      }
    } else if (postResult[CODE] == '2000') {
      Get.snackbar(
        'Success',
        'Post updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        colorText: snackbarColorText,
        backgroundColor: snackbarBackgroundColor,
      );
    } else {
      Get.snackbar(
        'Failure',
        'Post not updated!',
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        colorText: snackbarColorText,
        backgroundColor: snackbarBackgroundColor,
      );
    }
    await imageController.loadUserArticles(
        token: widget.token, userid: widget.userid);
    context.loaderOverlay.hide();
    Get.back();
  }
}
