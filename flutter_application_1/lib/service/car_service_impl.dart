import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/Utils/string_const.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/service/car_service.dart';

class CarServiceImpl implements CarService {
  List<Car> carList = [];

  @override
  Future<ApiResponse> saveCar(Car car) async {
    bool isSuccess = false;

    if (await Helper.isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("carsDb")
            .add(car.toJson())
            .then(
          (value) {
            isSuccess = true;
          },
        );
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
  Future<ApiResponse> getCar() async {
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        var value = await FirebaseFirestore.instance.collection("carsDb").get();
        var carList = value.docs.map((e) => Car.fromJson(e.data())).toList();
        for (int i = 0; i < carList.length; i++) {
          carList[i].id = value.docs[i].id;
        }
        return ApiResponse(statusUtil: StatusUtil.success, data: carList);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.success, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
    }
  }

  @override
  Future<ApiResponse> deleteCar(String id) async {
    bool isSuccess = false;
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("carsDb")
            .doc(id)
            .delete()
            .then(
          (value) {
            isSuccess = true;
          },
        );

        return ApiResponse(statusUtil: StatusUtil.success, data: isSuccess);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    }
    return ApiResponse(
        statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
  }

  @override
  Future<ApiResponse> updateCarData(Car car) async {
    try {
      await FirebaseFirestore.instance
          .collection("carsDb")
          .doc(car.id)
          .update(car.toJson());

      return ApiResponse(statusUtil: StatusUtil.success);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }
}
