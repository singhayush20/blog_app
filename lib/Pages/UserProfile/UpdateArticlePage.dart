import 'dart:developer';
import 'dart:io';

import 'package:blog_app/GetController/ImageController.dart';
import 'package:blog_app/Model/Post.dart';
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
    //Inject image controller
    // Get.lazyPut(() => ImageController());
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
                        color: Color.fromARGB(255, 190, 236, 227),
                        child: Stack(
                          children: [
                            (_uploadButtonClicked == true)
                                ? Container(
                                    alignment: Alignment.center,
                                    child: imageController.pickedFile != null
                                        ? Image.file(
                                            File(imageController
                                                .pickedFile!.path),
                                            fit: BoxFit.cover,
                                          )
                                        : Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                height: height * 0.2,
                                                child: Image.asset(
                                                  'images/category_default.jpg',
                                                ),
                                              ),
                                              Text(
                                                'Your image appears here',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.sp,
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
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    imageController.pickImage();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
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
                                    child: Center(
                                      child: Hero(
                                        tag: 'imageHero',
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://imagedbspringboot.blob.core.windows.net/imagecontainer/${widget.post.image}',
                                          placeholder: (context, url) => Center(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child: DataLoadingIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'images/category_default.jpg'),
                                          fit: BoxFit.scaleDown,
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
                                      ? FontAwesomeIcons.xmark
                                      : FontAwesomeIcons.upload,
                                  size: 15.sp,
                                  color: Color.fromARGB(208, 0, 0, 0),
                                ),
                              ),
                            ),
                          ],
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
        Get.snackbar('Success', 'Post updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (postResult[CODE] == '2000') {
      Get.snackbar('Success', 'Post updated successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Failure', 'Post not updated!',
          snackPosition: SnackPosition.BOTTOM);
    }
    await imageController.loadUserArticles(
        token: widget.token, userid: widget.userid);
    context.loaderOverlay.hide();
    Get.back();
  }
}
