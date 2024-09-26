import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/Utils/string_const.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/view/user%20login/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User1? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
    getUserData();
    getCarData();
  }

  String? name, email, role;

  getValue() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      name = prefs.getString("name");
      email = prefs.getString("email");
      role = prefs.getString("role");

      // var provider = Provider.of<CarProvider>(context, listen: false);
      // await provider.getCar();

      // setState(() {
      //   // user = User1(email: email, name: name, role: role);
      // });
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

  @override
  Widget build(BuildContext context) {
    List<Brand> brandList = [
      Brand(brandImg: "assets/images/redcar1.png", brandName: "BMW"),
      Brand(
          brandImg: "assets/images/redcar1.png",
          brandName: "Lamborghini Avantador"),
      Brand(brandImg: "assets/images/redcar1.png", brandName: "Audi"),
      Brand(brandImg: "assets/images/redcar1.png", brandName: "TATA"),
      Brand(
          brandImg: "assets/images/redcar1.png",
          brandName: "Lamborghini Avantador"),
      Brand(brandImg: "assets/images/redcar1.png", brandName: "Audi"),
    ];

    User1? user;

    // Get the current user
    // User? user1 = FirebaseAuth.instance.currentUser;

    // Fallback to email if displayName is null
    // String displayName = user1?.displayName ?? user1?.email ?? "User";

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
          backgroundColor: Color(0xff771616),
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Color(0xFF771616),
            leading: Padding(
              padding: const EdgeInsets.only(top: 8, left: 20),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/Jackie-Chan.jpeg"),

                // backgroundColor: Colors.transparent,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Text(
                name ?? "",
                // "",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 8),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 27.5,
                    )),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Consumer<CarProvider>(
              builder: (context, carProvider, child) => carProvider
                          .getCarStatus ==
                      StatusUtil.loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .6,
                            child: ClipRect(
                              child: Image.asset(
                                "assets/images/redcar1.png",
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          12), // Padding inside the search bar
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                        .8), // Background color for the search bar
                                    borderRadius: BorderRadius.circular(
                                        30), // Rounded corners
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search...", // Placeholder text
                                      border:
                                          InputBorder.none, // Remove underline
                                      icon: Icon(Icons.search), // Search icon
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white.withOpacity(.1)),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      size: 35,
                                      Icons.filter_list,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              color: Colors.brown[900]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 20, top: 5),
                                    child: Text(
                                      "Brands",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SizedBox(
                                  height: 155,
                                  child: ListView.builder(
                                    itemCount: carProvider.carList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Container(
                                          height: 150,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white
                                                  .withOpacity(0.1)),
                                          child: Column(children: [
                                            // SizedBox(
                                            //   height: 90,
                                            //   width: 90,
                                            //   child: ClipRRect(
                                            //     borderRadius:
                                            //         BorderRadius.circular(20),
                                            //     child: Image.asset(
                                            //     brandList[index].brandImg!,,
                                            //     fit: BoxFit.contain,
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                // brandList[index].brandName!,
                                                carProvider
                                                    .carList[index].model!,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          ]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  "Cars",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 1,
                                      scrollDirection: Axis.vertical,
                                      physics: ScrollPhysics(),
                                      children: List.generate(
                                        brandList.length,
                                        (index) {
                                          return SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: Card(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/redcar1.png",
                                                    height: 120,
                                                    width: 177,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(brandList[index]
                                                      .brandName!)
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          )),
    );
  }
}

class Brand {
  String? brandImg, brandName;
  Brand({this.brandImg, this.brandName});
}
