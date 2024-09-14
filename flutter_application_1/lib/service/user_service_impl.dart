import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/Utils/string_const.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/service/user_service.dart';

class UserServiceImpl extends UserService {
  List<User> userList = [];

  @override
  Future<ApiResponse> saveUser(user) async {
    bool isSuccess = false;

    if (await Helper.isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("RentIt")
            .add(user.toJson())
            .then((value) {
          isSuccess = true;
        });
        return ApiResponse(statusUtil: StatusUtil.success, data: isSuccess);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
    }
  }

  @override
  Future<ApiResponse> getUser() async {
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("RentIt")
            .get()
            .then((value) {
          userList.addAll(value.docs.map((value) {
            final user = User.fromJson(value.data());
            //  user.id = value.id;
            return user;
          }).toList());
          print(userList);
        });
        return ApiResponse(statusUtil: StatusUtil.success, data: userList);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
    }
  }

  @override
  Future<ApiResponse> checkUserData(User user) async {
    bool isUserExists = false;
    try {
      await FirebaseFirestore.instance
          .collection("RentIt")
          .where("email", isEqualTo: user.email)
          .where("password", isEqualTo: user.password)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          isUserExists = true;
        }
      });
      return ApiResponse(statusUtil: StatusUtil.success, data: isUserExists);
    } catch (e) {
      return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
    }
  }

  @override
  Future<ApiResponse> doesEmailExistOnSignUp(User user) async {
    bool isEmailExist = false;
    try {
      var value = await FirebaseFirestore.instance
          .collection("RentIt")
          .where("email", isEqualTo: user.email)
          .get();
      if (value.docs.isNotEmpty) {
        isEmailExist = true;
      }

      return ApiResponse(statusUtil: StatusUtil.success, data: isEmailExist);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> doesMobileNumberExistOnSignUp(User user) async {
    bool isMobileNumberExist = false;
    try {
      var value = await FirebaseFirestore.instance
          .collection("RentIt")
          .where("mobileNumber", isEqualTo: user.mobileNumber)
          .get();
      if (value.docs.isNotEmpty) {
        isMobileNumberExist = true;
      }
      return ApiResponse(
          statusUtil: StatusUtil.success, data: isMobileNumberExist);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }
}
