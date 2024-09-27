import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/custom_book_button.dart';
import 'package:flutter_application_1/shared/custom_book_textfield.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({super.key});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }

  String? name, email, role;

  getValue() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      name = prefs.getString("name");
      email = prefs.getString("email");
      role = prefs.getString("role");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset("assets/images/redcar.png"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.2),
                ),
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .9,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Model: TATA 150s",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            "Year: 2021",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Vehical Type: Sedan",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            "Fuel Type: Petrol",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Seating Capacity: 4",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            "Mileage: 30 KM/h",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      Text(
                        "TransmissionType: Dont know",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "Brand: TATA",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Rental Price: 3200/day",
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Container(
                  color: Color(0xff181A1B),
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width * .9,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pick up Point",
                          style:
                              TextStyle(color: Color(0xffC3BEB6), fontSize: 16),
                        ),
                        CustomBookTextfield(
                          hintText: "Pick up Location",
                        ),
                        Text(
                          "Destination Point",
                          style:
                              TextStyle(color: Color(0xffC3BEB6), fontSize: 16),
                        ),
                        CustomBookTextfield(
                          hintText: "Destination Location",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Start Date",
                                    style: TextStyle(
                                        color: Color(0xffC3BEB6), fontSize: 16),
                                  ),
                                  CustomBookTextfield(
                                    hintText: "Start Date",
                                    suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.calendar_month,
                                          color: Color(0xff7B776D),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "End Date",
                                    style: TextStyle(
                                        color: Color(0xffC3BEB6), fontSize: 16),
                                  ),
                                  CustomBookTextfield(
                                    hintText: "End Date",
                                    suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.calendar_month,
                                          color: Color(0xff7B776D),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pick up Time",
                                    style: TextStyle(
                                        color: Color(0xffC3BEB6), fontSize: 16),
                                  ),
                                  CustomBookTextfield(
                                    // hintText: "Start Date",
                                    suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.watch_later_outlined,
                                          color: Color(0xff7B776D),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Drop Time",
                                    style: TextStyle(
                                        color: Color(0xffC3BEB6), fontSize: 16),
                                  ),
                                  CustomBookTextfield(
                                    // hintText: "End Date",
                                    suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.watch_later_outlined,
                                          color: Color(0xff7B776D),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        CustomBookButton(
                            onPressed: () {},
                            child: Text(
                              "Book Now",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
