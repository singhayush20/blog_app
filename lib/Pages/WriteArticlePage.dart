import 'dart:developer';
import 'dart:io';

import 'package:blog_app/Service/ImageController.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
// import 'package:flutter_quill/flutter_quill.dart' as qt hide Text;

class WriteArticlePage extends StatefulWidget {
  const WriteArticlePage({super.key});

  @override
  State<WriteArticlePage> createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  final AppBar _appBar = AppBar(
    title: Text('Write a new Article'),
  );
  // qt.QuillController _textEditorController = qt.QuillController.basic();
  SharedPreferences? _sharedPreferences;
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
      body: GetBuilder<ImageController>(builder: (imageController) {
        return LoaderOverlay(
          overlayWidget: Center(
            child: Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              child: CustomLoadingIndicator(),
            ),
          ),
          child: Column(
            children: [
              // qt.QuillToolbar.basic(controller: _textEditorController),
              // Expanded(
              //   child: Container(
              //     child: qt.QuillEditor.basic(
              //       controller: _textEditorController,
              //       readOnly: false, // true for view only mode
              //     ),
              //   ),
              // ),
              Center(
                child: TextButton(
                  child: Text('Select an Image'),
                  onPressed: () {
                    imageController.pickImage();
                  },
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                alignment: Alignment.center,
                // width: double.infinity,
                height: height * 0.3,
                color: Colors.grey[300],
                child: imageController.pickedFile != null
                    ? Image.file(
                        File(imageController.pickedFile!.path),
                        fit: BoxFit.cover,
                      )
                    : Text(
                        'Select an Image',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              ElevatedButton(
                  onPressed: (_sharedPreferences != null)
                      ? () async {
                          context.loaderOverlay.show();
                          bool result = await imageController.uploadImage(
                              postid: 52,
                              token:
                                  _sharedPreferences!.getString(BEARER_TOKEN)!,
                              isUpdatingPost: true);
                          context.loaderOverlay.hide();
                          if (result) {
                            Get.snackbar(
                                'Success', 'Image uploaded successfully!',
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar('Failure', 'Image upload failed!',
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                      : null,
                  child: Text('Save post')),
            ],
          ),
        );
      }),
    );
  }
}
