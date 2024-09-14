import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/user.dart';

abstract class UserService {
  Future<ApiResponse> saveUser(User user);
  Future<ApiResponse> getUser();
  Future<ApiResponse> checkUserData(User user);
  Future<ApiResponse> doesEmailExistOnSignUp(User user);
  Future<ApiResponse> doesMobileNumberExistOnSignUp(User user);
}
