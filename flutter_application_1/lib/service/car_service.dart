import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/car.dart';

abstract class CarService {
  Future<ApiResponse> saveCar(Car car);
  Future<ApiResponse> getCar();
  Future<ApiResponse> deleteCar(String id);
  Future<ApiResponse> updateCarData(Car car);
}
