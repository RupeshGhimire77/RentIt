import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/service/user_service.dart';
import 'package:flutter_application_1/service/user_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? name, email, password, confirmPassword, mobileNumber;
  String? errorMessage;

  bool isSuccess = false;
  String? role;

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isUserExist = false;
  bool isEmailExist = false;
  bool isMobileNumberExist = false;
  bool checkRemeberMe = false;
  bool isSignedInGoogle = false;

  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();

  isCheckedStatus(value) {
    checkRemeberMe = value!;
    notifyListeners();
  }

  setName(value) {
    name = value;
    notifyListeners();
  }

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  setPassword(value) {
    password = value;
    notifyListeners();
  }

  setConfirmPassword(value) {
    confirmPassword = value;
    notifyListeners();
  }

  setMobileNumber(value) {
    mobileNumber = value;
    notifyListeners();
  }

  setRole(value) {
    role = value;
    notifyListeners();
  }

  List<User> userList = [];
  UserService userService = UserServiceImpl();

  StatusUtil _saveUserStatus = StatusUtil.none;
  StatusUtil get saveUserStatus => _saveUserStatus;

  StatusUtil _getUserStatus = StatusUtil.none;
  StatusUtil get getUserStatus => _getUserStatus;

  StatusUtil _getLoginUserStatus = StatusUtil.none;
  StatusUtil get getLoginUserStatus => _getLoginUserStatus;

  StatusUtil _getCheckEmailExistInSignUp = StatusUtil.none;
  StatusUtil get getCheckEmailExistInSignUp => _getCheckEmailExistInSignUp;

  StatusUtil _getCheckMobileNumberOnSignUp = StatusUtil.none;
  StatusUtil get getCheckMobileNumberOnSignup => _getCheckMobileNumberOnSignUp;

  setGetCheckMobileNumberOnSignUp(StatusUtil status) {
    _getCheckEmailExistInSignUp = status;
    notifyListeners();
  }

  setGetCheckEmailExistInSignUP(StatusUtil status) {
    _getCheckEmailExistInSignUp = status;
    notifyListeners();
  }

  setSaveUserStatus(StatusUtil status) {
    _saveUserStatus = status;
    notifyListeners();
  }

  setGetUserStatus(StatusUtil status) {
    _getUserStatus = status;
    notifyListeners();
  }

  setGetLoginUserStatus(StatusUtil status) {
    _getLoginUserStatus = status;
    notifyListeners();
  }

  Future<void> saveUser() async {
    if (_saveUserStatus != StatusUtil.loading) {
      setSaveUserStatus(StatusUtil.loading);
    }

    User user = User(
        role: role,
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        mobileNumber: mobileNumber);

    ApiResponse response = await userService.saveUser(user);

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = response.data;
      setSaveUserStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setSaveUserStatus(StatusUtil.error);
    }
  }

  Future<void> getUser() async {
    if (_getUserStatus == StatusUtil.loading) {
      setGetUserStatus(StatusUtil.loading);

      ApiResponse response = await userService.getUser();
      if (_getUserStatus == StatusUtil.success) {
        userList = response.data;
        setGetUserStatus(StatusUtil.success);
      } else if (_getUserStatus == StatusUtil.error) {
        errorMessage = response.errorMessage;
        setGetUserStatus(StatusUtil.error);
      }
    }
  }

  Future<void> checkEmailonSignUp() async {
    if (_getCheckEmailExistInSignUp != StatusUtil.loading) {
      setGetCheckEmailExistInSignUP(StatusUtil.loading);
    }
    User user = User(email: email);
    ApiResponse response = await userService.doesEmailExistOnSignUp(user);

    if (response.statusUtil == StatusUtil.success) {
      isEmailExist = response.data;
      setGetCheckEmailExistInSignUP(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetCheckEmailExistInSignUP(StatusUtil.error);
    }
  }

  Future<void> checkMobileNumberOnSignUp() async {
    if (_getCheckMobileNumberOnSignUp != StatusUtil.loading) {
      setGetCheckMobileNumberOnSignUp(StatusUtil.loading);
    }

    User user = User(mobileNumber: mobileNumber);
    ApiResponse response =
        await userService.doesMobileNumberExistOnSignUp(user);

    if (response.statusUtil == StatusUtil.success) {
      isMobileNumberExist = response.data;
      setGetCheckMobileNumberOnSignUp(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetCheckMobileNumberOnSignUp(StatusUtil.error);
    }
  }

  Future<void> loginUser() async {
    if (getLoginUserStatus != StatusUtil.loading) {
      setGetLoginUserStatus(StatusUtil.loading);
    }
    User user =
        User(email: emailTextField.text, password: passwordTextField.text);

    ApiResponse response = await userService.checkUserData(user);

    if (response.statusUtil == StatusUtil.success) {
      isUserExist = response.data;
      setGetLoginUserStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetLoginUserStatus(StatusUtil.error);
    }
  }

  storeValueToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
  }

  rememberMe(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString("email", emailTextField.text);
      await prefs.setString("password", passwordTextField.text);
    } else {
      await prefs.remove('rememberMe');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  readRememberMe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emailTextField.text = await prefs.getString('email') ?? "";
    passwordTextField.text = await prefs.getString('password') ?? "";
    notifyListeners();
  }
}
