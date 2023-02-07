import 'package:blog_app/Model/Comment.dart';
import 'package:blog_app/network_util/API.dart';

class CommentService {
  final API _api = API();

  Future<List<Comment>> getAllCommentsForPost(
      {required String token, required int postid}) async {
    List<Comment> comments = [];
    Map<String, dynamic> result =
        await _api.getAllCommentsForPost(token: token, postid: postid);
    if (result['code'] == '2000') {
      comments = commentFromJson(result['data']);
    }
    return comments;
  }
}
