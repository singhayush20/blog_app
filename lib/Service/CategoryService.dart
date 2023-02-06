import 'package:blog_app/network_util/API.dart';

class CategoryService {
  final API _api = API();

  Future<Map<String, dynamic>> fetchAllCategories(
      {required String token}) async {
    Map<String, dynamic> result = await _api.getAllCategories(token: token);
    return result;
  }
}
