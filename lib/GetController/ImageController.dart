import 'dart:convert';
import 'dart:developer';

import 'package:blog_app/Model/Post.dart';
import 'package:blog_app/Service/PostService.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageController extends GetxController {
  final API _api = API();
  final _picker = ImagePicker();
  // File? _image;
  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;
  Future<void> pickImage() async {
    //getImage method is deprecated for ImagePicker
    _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    // _image = File(_pickedFile!.path);
    update();
  }

  removeImage() {
    _pickedFile = null;
    update();
  }

  Future<bool> uploadImage(
      {required int postid,
      required String token,
      required bool isUpdatingPost}) async {
    update();
    bool success = false;
    http.StreamedResponse response = await _api.uploadImage(
        data: _pickedFile,
        token: token,
        postid: postid,
        isUpdatingPost: isUpdatingPost);
    log('image upload response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      log('image upload response: $map');
      if (map[CODE] == '2000') {
        String message = map["data"];
        success = true;
        log("Image upload message: $message");
      } else {
        log('Some error occured while uploading image');
      }
    } else {
      log('Error uploading image');
    }
    update();
    return success;
  }

  List<Post> _userArticles = [];
  List<Post> get userArticles => _userArticles;
  final PostService _postService = PostService();
  //Articles
  Future<void> loadUserArticles(
      {required String token, required int userid}) async {
    log('loading user articles');
    final result =
        await _postService.getAllPostsForUser(token: token, userid: userid);
    _userArticles = result;
    update();
  }
}
