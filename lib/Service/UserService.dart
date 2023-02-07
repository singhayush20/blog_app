import 'package:blog_app/Model/User.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';

class UserService {
  final API _api = API();

  Future<String> registerUser(
      {required String password,
      required String email,
      required String about,
      required String firstName,
      required String lastName}) async {
    Map<String, dynamic> data = {
      "password": password,
      "email": email,
      "about": about,
      "firstName": firstName,
      "lastName": lastName
    };
    Map<String, dynamic> result = await _api.register(userData: data);
    return result[CODE];
  }

  Future<User?> getUserDetails(
      {required String token, required String email}) async {
    User? user;
    Map<String, dynamic> result =
        await _api.getUserProfileData(email: email, token: token);
    if (result['code'] == '2000') {
      user = userFromJson(result['data']);
    }
    return user;
  }
}
