class Car {
  String? model;
  String? year;
  String? vehicleType;
  String? seatingCapacity;
  String? transmissionType;
  String? fuelType;
  String? mileage;
  String? rentalPrice;
  String? image;

  Car(
      {this.model,
      this.year,
      this.vehicleType,
      this.seatingCapacity,
      this.transmissionType,
      this.fuelType,
      this.mileage,
      this.rentalPrice,
      this.image});

  Car.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    year = json['year'];
    vehicleType = json['vehicleType'];
    seatingCapacity = json['seatingCapacity'];
    transmissionType = json['transmissionType'];
    fuelType = json['fuelType'];
    mileage = json['mileage'];
    rentalPrice = json['rentalPrice'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['year'] = this.year;
    data['vehicleType'] = this.vehicleType;
    data['seatingCapacity'] = this.seatingCapacity;
    data['transmissionType'] = this.transmissionType;
    data['fuelType'] = this.fuelType;
    data['mileage'] = this.mileage;
    data['rentalPrice'] = this.rentalPrice;
    data['image'] = this.image;
    return data;
  }
}
