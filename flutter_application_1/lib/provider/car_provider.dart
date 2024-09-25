import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/service/car_service.dart';
import 'package:flutter_application_1/service/car_service_impl.dart';

class CarProvider extends ChangeNotifier {
  String? model,
      year,
      // image,
      transmissionType,
      vehicalType,
      seatingCapacity,
      fuelType,
      mileage,
      rentalPrice;
  String? errorMessage;
  TextEditingController? imageTextField;

  bool isSuccess = false;

  setModel(value) {
    model = value;
  }

  setYear(value) {
    year = value;
  }

  setImage(value) {
    imageTextField = TextEditingController(text: value);
  }

  setTransmissionType(value) {
    transmissionType = value;
  }

  setVehicalType(value) {
    vehicalType = value;
  }

  setSeatingCapactiy(value) {
    seatingCapacity = value;
  }

  setFuelType(value) {
    fuelType = value;
  }

  setMileage(value) {
    mileage = value;
  }

  setRentalPrice(value) {
    rentalPrice = value;
  }

  List<Car> carList = [];
  CarService carService = CarServiceImpl();

  StatusUtil _saveCarStatus = StatusUtil.none;
  StatusUtil get saveCarStatus => _saveCarStatus;

  StatusUtil _getCarStatus = StatusUtil.none;
  StatusUtil get getCarStatus => _getCarStatus;

  setSaveCarStatus(StatusUtil status) {
    _saveCarStatus = status;
    notifyListeners();
  }

  setGetCarStatus(StatusUtil status) {
    _getCarStatus = status;
    notifyListeners();
  }

  Future<void> saveCar() async {
    if (_saveCarStatus != StatusUtil.loading) {
      setSaveCarStatus(StatusUtil.loading);
    }

    Car car = Car(
        model: model,
        year: year,
        image: imageTextField!.text,
        vehicleType: vehicalType,
        fuelType: fuelType,
        mileage: mileage,
        transmissionType: transmissionType,
        seatingCapacity: seatingCapacity,
        rentalPrice: rentalPrice);

    ApiResponse response = await carService.saveCar(car);
    if (response.statusUtil == StatusUtil.success) {
      isSuccess = true;
      setSaveCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setSaveCarStatus(StatusUtil.error);
    }
  }

  Future<void> getCar() async {
    if (_getCarStatus != StatusUtil.loading) {
      setGetCarStatus(StatusUtil.loading);
    }

    ApiResponse response = await carService.getCar();
    if (response.statusUtil == StatusUtil.success) {
      carList = response.data;
      setGetCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetCarStatus(StatusUtil.error);
    }
  }
}
