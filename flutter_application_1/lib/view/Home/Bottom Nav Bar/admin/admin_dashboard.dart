import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/Utils/string_const.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/view/Home/Bottom%20Nav%20Bar/admin/admin_bottom_navbar.dart';
import 'package:flutter_application_1/view/user%20login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  User1? user;
  Car? car;
  AdminDashboard({super.key, this.user, this.car});

  @override
  State<AdminDashboard> createState() => AdminDashboardState();
}

class AdminDashboardState extends State<AdminDashboard> {
  List<String> adminMethods = [
    "Add Cars",
    "User's List",
    "Cars List",
    "Rented Cars"
  ];
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> widgetOptions = <Widget>[
    Text(
      'Add Cars',
      style: optionStyle,
    ),
    Text(
      "User's List",
      style: optionStyle,
    ),
    Text(
      "Cars List",
      style: optionStyle,
    ),
    Text(
      "Rented Cars",
      style: optionStyle,
    )
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.car != null) {
      var provider = Provider.of<CarProvider>(context, listen: false);
      provider.id = widget.car!.id ?? "";
      provider.model = widget.car!.model ?? "";
      provider.year = widget.car!.year ?? "";
      provider.image = widget.car!.image ?? "";
      provider.transmissionType = widget.car!.transmissionType ?? "";
      provider.vehicalType = widget.car!.vehicleType ?? "";
      provider.seatingCapacity = widget.car!.seatingCapacity ?? "";
      provider.fuelType = widget.car!.fuelType ?? "";
      provider.mileage = widget.car!.mileage ?? "";
      provider.rentalPrice = widget.car!.rentalPrice ?? "";
    }

    super.initState();
    getValue();
    getUserData();
    getCarData();
  }

  String? name, email, role;
  bool isLoading = true;
  getValue() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      name = prefs.getString("name");
      email = prefs.getString("email");
      role = prefs.getString("role");
      setState(() {
        isLoading = false;
      });
    });
  }

  getUserData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<UserProvider>(context, listen: false);
        await provider.getUser();
      },
    );
  }

  getCarData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<CarProvider>(context, listen: false);
        await provider.getCar();
      },
    );
  }

  File file = File("");
  String? downloadUrl;

  bool loader = false;

  final _formKey = GlobalKey<FormState>();

  String? model,
      year,
      image,
      transmissionType,
      vehicalType,
      seatingCapacity,
      fuelType,
      mileage,
      rentalPrice;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff771616),
            title: Text(
              name ?? "",
              style: TextStyle(color: Colors.white),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu),
                  color: Colors.white,
                  iconSize: 35,
                );
              },
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xff771616)),
                    child: Text(
                      "Admin Panel",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )),
                ListTile(
                  title: const Text("Add Cars"),
                  selected: selectedIndex == 0,
                  onTap: () {
                    onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("User's List"),
                  selected: selectedIndex == 1,
                  onTap: () {
                    onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Cars List"),
                  selected: selectedIndex == 2,
                  onTap: () {
                    onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Rented Cars"),
                  selected: selectedIndex == 3,
                  onTap: () {
                    onItemTapped(3);
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: CustomButton(
                      onPressed: () {
                        logoutShowDialog(context, userProvider);
                      },
                      child: Text(
                        "logout",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Consumer<CarProvider>(
              builder: (context, carProvider, child) => Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widgetOptions[selectedIndex],
                  ],
                ),
                if (selectedIndex == 0)
                  _buildAddCarForm()
                else if (selectedIndex == 1)
                  _buildUserList(userProvider)
                else if (selectedIndex == 2)
                  _buildCarList(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCarForm() {
    return Consumer<CarProvider>(
      builder: (context, carProvider, child) => Form(
          key: _formKey,
          child: Column(
            children: [
              // SizedBox(
              //         height: MediaQuery.of(context).size.height * 0.2,
              //         width: MediaQuery.of(context).size.width * 0.6,
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(
              //               8.0), // Optional: Add rounded corners
              //           child: Image.asset(
              //             "assets/images/background.png",
              //             fit: BoxFit
              //                 .contain, // Use BoxFit.cover to fill the box
              //           ),
              //         ),
              //       ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.6,
                child: file.path.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          file,
                          fit: BoxFit.contain,
                        ),
                      )
                    : (downloadUrl != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              downloadUrl!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              "assets/images/background.png",
                              fit: BoxFit.contain,
                            ),
                          ),
              ),
              CustomButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: loader == true
                      ? CircularProgressIndicator()
                      : Text(
                          "Upload Image",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
              if (downloadUrl != null)
                Visibility(
                  visible: false,
                  child: CustomTextFormField(
                    controller: carProvider.setImage(downloadUrl!),
                    labelText: "Car Image",
                  ),
                ),
              CustomTextFormField(
                initialValue: carProvider.model,
                labelText: modelCarStr,
                onChanged: (p0) {
                  carProvider.setModel(p0);
                },
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return carValidStr;
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                initialValue: carProvider.year,
                onChanged: (p0) {
                  carProvider.setYear(p0);
                },
                labelText: carYearStr,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return carValidStr;
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                initialValue: carProvider.transmissionType,
                onChanged: (p0) {
                  carProvider.setTransmissionType(p0);
                },
                labelText: transmissionTypeStr,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return carValidStr;
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                initialValue: carProvider.seatingCapacity,
                onChanged: (p0) {
                  carProvider.setSeatingCapactiy(p0);
                },
                labelText: seatingCapacityStr,
              ),
              CustomTextFormField(
                initialValue: carProvider.vehicalType,
                onChanged: (p0) {
                  carProvider.setVehicalType(p0);
                },
                labelText: vehicalTypeStr,
              ),
              CustomTextFormField(
                initialValue: carProvider.fuelType,
                onChanged: (p0) {
                  carProvider.setFuelType(p0);
                },
                labelText: fuelTypeStr,
              ),
              CustomTextFormField(
                initialValue: carProvider.mileage,
                onChanged: (p0) {
                  carProvider.setMileage(p0);
                },
                labelText: mileageStr,
              ),
              CustomTextFormField(
                initialValue: carProvider.rentalPrice,
                onChanged: (p0) {
                  carProvider.setRentalPrice(p0);
                },
                labelText: rentalPriceStr,
                keyboardType: TextInputType.number,
              ),
              CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await carProvider.saveCar();
                      if (carProvider.saveCarStatus == StatusUtil.success) {
                        await Helper.displaySnackBar(
                            context, "Car Successfully Saved.");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminBottomNavBar(
                              initialIndex: 0,
                            ),
                          ),
                          (route) => false,
                        );
                      }
                    } else if (carProvider.saveCarStatus == StatusUtil.error) {
                      Helper.displaySnackBar(
                          context, "Car Could not be Saved.");
                    }
                  },
                  child: carProvider.saveCarStatus == StatusUtil.loading
                      ? CircularProgressIndicator()
                      : Text(
                          'Add Car',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
            ],
          )),
    );
  }

// Method to build the User List
  Widget _buildUserList(UserProvider userProvider) {
    if (userProvider.userList.isEmpty) {
      return Center(child: Text("No users found."));
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
        itemCount: userProvider.userList.length,
        itemBuilder: (context, index) {
          final user = userProvider.userList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${user.name ?? "Unknown"}"),
                  Text("Email: ${user.email ?? "N/A"}"),
                  Text("Contact: ${user.mobileNumber ?? "N/A"}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

// Method to build the Car List
  Widget _buildCarList() {
    // Implement similar to _buildUserList
    return Consumer<CarProvider>(
      builder: (context, carProvider, child) {
        if (carProvider.carList.isEmpty) {
          return Center(child: Text("No cars found."));
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: carProvider.carList.length,
            itemBuilder: (context, index) {
              final car = carProvider.carList[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Car Model: ${car.model ?? "Unknown"}"),
                          Text("Vehicle Type: ${car.vehicleType ?? "N/A"}"),
                          Text("Year: ${car.year ?? "N/A"}"),
                          // Text("Id: ${car.id ?? "null"}")
                          Text("Rental Price: ${car.rentalPrice ?? "N/A"}")
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            editShowDialog(context, carProvider,
                                carProvider.carList[index]);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () async {
                            String id = carProvider.carList[index].id!;
                            await deleteShowDialog(context, carProvider, id);
                            // carProvider.deleteCar(carProvider.carList[index].id!);
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLogin");
    await Helper.displaySnackBar(context, logoutSuccessfullStr);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
  }

  logoutShowDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                logout();
                // signOut();
                Helper.displaySnackBar(context, "Logout Successfull!");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                    (route) => false);

                // Perform delete operation here
                // Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  deleteShowDialog(BuildContext context, CarProvider carProvider, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Car'),
          content: Text('Are you sure you want to delete this car?'),
          actions: [
            TextButton(
              onPressed: () async {
                await carProvider.deleteCar(id);

                if (carProvider.deleteCarStatus == StatusUtil.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Car deleted successfully!")),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminBottomNavBar(
                              initialIndex: 1,
                            )),
                    (route) => false,
                  );
                  // Navigator.pop(context);
                } else if (carProvider.deleteCarStatus == StatusUtil.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to delete car.")),
                  );
                }
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  editShowDialog(BuildContext context, CarProvider carProvider, Car car) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit'),
          content: Text('Are you sure you want to Edit?'),
          actions: [
            TextButton(
              onPressed: () async {
                await carProvider.saveCar();
                //edit operation
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminDashboard(
                              car: car,
                            )),
                    (route) => false); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  pickImage() async {
    setState(() {
      // loader = true; // Set loader to true before upload
    });

    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // User might have canceled

    file = File(image.path);
    setState(() {
      file; // Update file state for preview
    });

    try {
      String fileName = file.path.split('/').last;
      var storageReference = FirebaseStorage.instance.ref().child('Rental');
      var uploadReference = storageReference.child(fileName);
      await uploadReference.putFile(file);
      downloadUrl = await uploadReference.getDownloadURL();

      setState(() {
        downloadUrl; // Update downloadUrl for the form field
        loader = false; // Hide loader after successful upload
      });
    } catch (e) {
      setState(() {
        loader = false; // Hide loader even on error
      });
      print(e); // Print error for debugging
    }
  }
}
