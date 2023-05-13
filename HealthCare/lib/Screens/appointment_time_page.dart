import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_appointment/constants.dart';
import 'package:intl/intl.dart';
import '../models/patient_data.dart';
import 'home/patient_home_page.dart';

class Appoin_time extends StatefulWidget {
  var uid;
  var name;
  var gender;

  Appoin_time({
    this.uid,
    this.name,
    this.gender,
  });

  @override
  _Appoin_timeState createState() => _Appoin_timeState();
}

class _Appoin_timeState extends State<Appoin_time> {
  final morining =
    "08:00AM - 12:00PM";
  final afternoon =
    "12:00PM - 06:00PM";
  final evening =
    "06:00PM - 10:00PM";
  final AllDay =
      "08:00PM - 10:00PM";
  bool isEnabled1 = false;
  bool sloact_book = false;
  var isEnabled2 = 2;
  var mydate;
  var c_date;
  var time;
  final now = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var firestoreInstance = FirebaseFirestore.instance;
  var today_app1 = 0;
  var today_app2 = 0;
  var today_app3 = 0;
  var today_app4 = 0;
  var today_app5 = 0;
  var today_app6 = 0;
  var today_app7 = 0;

  var timeslot;

  @override
  void initState() {
    super.initState();
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("parent")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());

      setState(() {});

      print("++++++++++++++++++++++++++++++++++++++++++" + user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Appointment Time",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () async {
                      mydate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 1)),
                          firstDate: DateTime.now().add(Duration(days: 1)),
                          lastDate: DateTime.now().add(Duration(days: 2)));

                      setState(() {
                        c_date = DateFormat('dd-MM-yyyy').format(mydate);
                      });
                    },
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          c_date == null
                              ? Text(
                            "Select Date",
                            style: TextStyle(color: Colors.white),
                          )
                              : Text(
                            c_date,
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                //************************************************
                //  MORNING
                //************************************************
                Row(
                  children: [
                    Icon(
                      Icons.wb_twighlight,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "MORNING",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MORNING Button 1.........................................
                    GestureDetector(
                        child: today_app1 >= 2
                            ? time_Button(morining)
                            : Container(
                            height: 50,
                            width: 150,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: time == morining
                                  ? Colors.green
                                  : kPrimaryColor,
                            ),
                            child: Center(
                                child: Text(
                                  morining,
                                  style: TextStyle(color: Colors.white),
                                )) // child widget, replace with your own
                        ),
                        onTap: () {
                          if (today_app1 < 2) {
                            if (c_date == null) {
                              Fluttertoast.showToast(
                                  msg: " Please Select Date First");
                            } else {
                              time = morining;
                              timeslot = 1;
                              isEnabled1 = true;
                            }
                          } else
                            Fluttertoast.showToast(msg: "Slot Full");
                        }),


               ] ),

                //************************************************
                //  AFTERNOON
                //************************************************
                Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.amber),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "AFTERNOON",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AFTERNOON Button 1.......................................
                    GestureDetector(
                      onTap: () {
                        if (today_app3 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First");
                          } else {
                            time = afternoon;
                            timeslot = 3;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app3 >= 2
                          ? time_Button(afternoon)
                          : Container(
                          height: 50,
                          width: 150,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: time == afternoon
                                ? Colors.green
                                : kPrimaryColor,
                          ),
                          child: Center(
                              child: Text(
                                afternoon,
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                      ),
                    ),

                  ],
                ),

                //************************************************
                //  EVENING
                //************************************************
                Row(
                  children: [
                    Icon(Icons.wb_twighlight, color: Colors.amber),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "EVENING",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // EVENING Button 1.........................................
                    GestureDetector(
                      onTap: () {
                        if (today_app6 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First");
                          } else {
                            time = evening;
                            timeslot = 6;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app6 >= 2
                          ? time_Button(evening)
                          : Container(
                          height: 50,
                          width: 150,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: time == evening
                                ? Colors.green
                                : kPrimaryColor,
                          ),
                          child: Center(
                              child: Text(
                                evening,
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                      ),
                    ),

                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.wb_twighlight,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "All Day",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // MORNING Button 1.........................................
                      GestureDetector(
                          child: today_app1 >= 2
                              ? time_Button(AllDay)
                              : Container(
                              height: 50,
                              width: 150,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: time == AllDay
                                    ? Colors.green
                                    : kPrimaryColor,
                              ),
                              child: Center(
                                  child: Text(
                                    AllDay,
                                    style: TextStyle(color: Colors.white),
                                  )) // child widget, replace with your own
                          ),
                          onTap: () {
                            if (today_app1 < 2) {
                              if (c_date == null) {
                                Fluttertoast.showToast(
                                    msg: " Please Select Date First");
                              } else {
                                time = AllDay;
                                timeslot = 1;
                                isEnabled1 = true;
                              }
                            } else
                              Fluttertoast.showToast(msg: "Slot Full");
                          }),


                    ] ),

                SizedBox(
                  height: size.height * 0.23,
                ),
                Center(
                  child: Container(
                    width: size.width * 0.8,
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: isEnabled1
                          ? () {
                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        firebaseFirestore
                            .collection('pending')
                            .add({
                          'pid': loggedInUser.uid.toString(),
                          'name': loggedInUser.name.toString() +
                              " " +
                              loggedInUser.last_name.toString(),
                          'date': c_date,
                          'time': time,
                          'approve': false,
                          'did': widget.uid,
                          'gender':widget.gender.toString(),
                          'phone': loggedInUser.phone,
                          'doctor_name': widget.name.toString(),
                          'visited': false,
                        })
                            .then((value) => Fluttertoast.showToast(
                            msg: "Pending Appointment",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: kPrimaryColor,
                            textColor: Colors.white,
                            fontSize: 16.0))
                            .then((value) => showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) =>
                                AdvanceCustomAlert(
                                    widget.name.toString())))
                            .catchError((e) {
                          print('Error Data2' + e.toString());
                        });
                      }
                          : null,
                      child: Text(
                        'Book Appointment',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: morining)
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app1 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),

                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                    // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: afternoon)
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app3 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),

                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                    // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: evening)
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app6 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),

                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: AllDay)
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app1 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget time_Button(time) {
    return Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black26,
        ),
        child: Center(
            child: Text(
              time,
              style: TextStyle(color: Colors.white),
            )) // child widget, replace with your own
    );
  }

  Widget time_Button_active(
      time,
      button_time,
      ) {
    return Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: time == button_time ? Colors.green : kPrimaryColor,
        ),
        child: Center(
            child: Text(
              time,
              style: TextStyle(color: Colors.white),
            )) // child widget, replace with your own
    );
  }
}

class AdvanceCustomAlert extends StatelessWidget {
  var name;
  var gender;

  AdvanceCustomAlert(String name) {
    this.name = name;
    this.gender=gender;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          // overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 120, 10, 10),
                child: Column(
                  children: [
                    Text(
                      (gender== 'female' ? 'Ms.  ' : 'Mrs.  ') + name,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Pending till doctor confirm this appointment request.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => HomePage()),
                                (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor),
                      child: Text(
                        'Okay',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 45,
                child: Image.asset('assets/images/logo1.png'),
              ),
            )
          ],
        ));
  }
}