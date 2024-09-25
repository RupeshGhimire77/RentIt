import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/Utils/string_const.dart';
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
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => AdminDashboardState();
}

class AdminDashboardState extends State<AdminDashboard> {
  User1? user;

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
    super.initState();
    getValue();
    getUserData();
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
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          file.path.isEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Add rounded corners
                                    child: Image.asset(
                                      "assets/images/background.png",
                                      fit: BoxFit
                                          .contain, // Use BoxFit.cover to fill the box
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    child: Image.file(file),
                                  ),
                                ),
                          CustomButton(
                              onPressed: () async {
                                await pickImage();
                              },
                              child: loader == true
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "Upload Image",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                          CustomTextFormField(
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
                          if (downloadUrl != null)
                            Visibility(
                              visible: false,
                              child: CustomTextFormField(
                                controller: carProvider.setImage(downloadUrl!),
                                labelText: "Car Image",
                              ),
                            ),
                          CustomTextFormField(
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
                            onChanged: (p0) {
                              carProvider.setSeatingCapactiy(p0);
                            },
                            labelText: seatingCapacityStr,
                          ),
                          CustomTextFormField(
                            onChanged: (p0) {
                              carProvider.setVehicalType(p0);
                            },
                            labelText: vehicalTypeStr,
                          ),
                          CustomTextFormField(
                            onChanged: (p0) {
                              carProvider.setFuelType(p0);
                            },
                            labelText: fuelTypeStr,
                          ),
                          CustomTextFormField(
                            onChanged: (p0) {
                              carProvider.setMileage(p0);
                            },
                            labelText: mileageStr,
                          ),
                          CustomTextFormField(
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
                                  if (carProvider.saveCarStatus ==
                                      StatusUtil.success) {
                                    await Helper.displaySnackBar(
                                        context, "Car Successfully Saved.");
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdminBottomNavBar(
                                          initialIndex: 1,
                                        ),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } else if (carProvider.saveCarStatus ==
                                    StatusUtil.error) {
                                  Helper.displaySnackBar(
                                      context, "Car Could not be Saved.");
                                }
                              },
                              child: Text(
                                'Add Car',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                          if (selectedIndex == 1)
                            Consumer<UserProvider>(
                              builder: (context, userProvider, child) =>
                                  SizedBox(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  itemCount: userProvider.userList.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Name: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              userProvider
                                                      .userList[index].name ??
                                                  "",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                        ],
                      ))
              ]),
            ),
          ),
        ),
      ),
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

  pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    setState(() {
      // loader = true;
      file;
    });
    try {
      // List<String> fileName = file.path.split('/');
      String fileName = file.path.split('/').last;
      var storageReference = FirebaseStorage.instance.ref();
      var uploadReference = storageReference.child(fileName);
      await uploadReference.putFile(file);
      downloadUrl = await uploadReference.getDownloadURL();
      setState(() {
        downloadUrl;
        loader = false;
      });
      // print("downloadUrl$downloadUrl");
    } catch (e) {
      setState(() {
        loader = false;
      });
    }
  }
}
