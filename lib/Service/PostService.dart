import 'package:blog_app/Model/Post.dart';
import 'package:blog_app/network_util/API.dart';

class PostService {
  final API _api = API();

  Future<Map<String, dynamic>> createPost(
      {required String token,
      required int userid,
      required int categoryid,
      required String title,
      required String content}) async {
    Map<String, String> post = {"title": title, "content": content};
    Map<String, dynamic> result = await _api.createPost(
        userid: userid, categoryid: categoryid, token: token, post: post);
    return result;
  }

  Future<List<Post>> getAllPostsForUser(
      {required String token, required int userid}) async {
    Map<String, dynamic> result =
        await _api.getAllPostsByUser(token: token, userid: userid);
    List<Post> posts = [];
    if (result['code'] == '2000') {
      posts = postFromJson(result['data']);
    }

    return posts;
  }
}
