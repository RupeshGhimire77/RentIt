import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/Utils/string_const.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/service/user_service.dart';

class UserServiceImpl extends UserService {
  List<User1> userList = [];

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
            final user = User1.fromJson(value.data());
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

  // @override
  // Future<ApiResponse> getIndividualUser(User user) async {
  //   bool userData = false;
  //   if (await Helper.isInternetConnectionAvailable()) {
  //     try {
  //       await FirebaseFirestore.instance
  //           .collection("RentIt")
  //           .where("id", isEqualTo: user.id)
  //           .get()
  //           .then((value) {
  //         if (value.docs.isNotEmpty) {
  //           userData = true;
  //         }
  //       });
  //       return ApiResponse(statusUtil: StatusUtil.success,data: userData);
  //     } catch (e) {
  //       return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
  //     }
  //   }
  // }

  @override
  Future<ApiResponse> checkUserData(User1 user) async {
    // bool isUserExists = false;
    User1? userData;

    try {
      await FirebaseFirestore.instance
          .collection("RentIt")
          .where("email", isEqualTo: user.email)
          .where("password", isEqualTo: user.password)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          // isUserExists = true;
          userData = User1.fromJson(value.docs[0].data());
        }
      });
      return ApiResponse(statusUtil: StatusUtil.success, data: userData);
    } catch (e) {
      return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
    }
  }

  @override
  Future<ApiResponse> doesEmailExistOnSignUp(User1 user) async {
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
  Future<ApiResponse> doesMobileNumberExistOnSignUp(User1 user) async {
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
