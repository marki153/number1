import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_appointment/theme/extention.dart';
import 'package:intl/intl.dart';

import '../Screens/home/doctor_home_page.dart';
import '../componets/loadingindicator.dart';
import '../models/doctor.dart';
import '../theme/text_styles.dart';
import '../widget/DoctorDrawer.dart';

class SearchList3 extends StatefulWidget {
  final String searchKey;

  const SearchList3({Key? key, required this.searchKey}) : super(key: key);

  @override
  _SearchList3State createState() => _SearchList3State();
}

class _SearchList3State extends State<SearchList3> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference firebase =
  FirebaseFirestore.instance.collection("Sitter");
  var appointment = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  late TabController tabController;
  DoctorModel loggedInUser = DoctorModel();

  /// ****************
  /// ACTIONS
  /// ****************

  /// ****************
  /// LIFE CYCLE METHODS
  /// ****************

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    loggedInUser = DoctorModel();
    FirebaseFirestore.instance
        .collection("Sitter")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = DoctorModel.fromMap(value.data());
      setState(() {
        sleep(Duration(microseconds: 10));
        isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    var firebase = appointment
        .collection('pending')
        .where('visited', isEqualTo: true)
        .where('approve', isEqualTo: true)
        .where('did', isEqualTo: loggedInUser.uid)
        .orderBy('name')
        .startAt([widget.searchKey.toLowerCase()]).endAt(
        [widget.searchKey.toLowerCase() + '\uf8ff']).snapshots();

    print(widget.searchKey);
    var size = MediaQuery.of(context).size;
    context1 = context;
    sleep(Duration(seconds: 1));
    return Scaffold(
      backgroundColor: Color(0xfffbfbfb),
      key: _scaffoldKey,
      drawer: loggedInUser.uid == null ? SizedBox() : DocDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Stack(
          children: [
            Positioned(
              top: 26,
              left: 3.5,
              child: Container(
                padding: EdgeInsets.fromLTRB(25 , 25, 25 , 25),
                decoration: BoxDecoration(
                  color: Color(0xff4ca6a8),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 46),
              alignment: Alignment.topCenter,
              child: Text(
                "Visited",
                style:  TextStyle (
                  fontFamily: 'Poppins',
                  fontSize: 30,
                  fontWeight:  FontWeight.w700,height: 1,
                  color:  Color(0xff4ca5a7),
                ),
              ),

            ),
          ],
        ),
      ),
      body: loggedInUser.uid == null
          ? Center(
        child: Text("Wait for few seconds"),
      )
          : SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text("Search Results For '"+widget.searchKey+"'", style:  TextStyle (
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: Color(0xff151313),
                ),)
            ),

            StreamBuilder<QuerySnapshot>(
                stream: firebase,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: size.height * 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 300),
                          child: Center(
                              child: Text(" You Do Not Have An Appointment today.", style: TextStyles.title.bold)),
                        ));
                  } else {
                    return isLoading
                        ? Container(
                      margin:
                      EdgeInsets.only(top: size.height * 0.4),
                      child: Center(
                        child: Loading(),
                      ),
                    )
                        : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder:
                            (BuildContext context, int index) {
                          final DocumentSnapshot doc =
                          snapshot.data!.docs[index];

                          return Padding(

                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Card(
                              color: Colors.blue[100],
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              ),
                            child: Container(
                              width: double.infinity, // Set the width to occupy the full available width
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    8.0),
                                color:
                                Colors.green.shade400,
                              ),

                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          width: double
                                              .infinity,
                                          decoration:
                                          BoxDecoration(),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left:
                                                8.0,
                                                top:
                                                8.0),
                                            child: Text(
                                              'Name: ' +
                                                  doc['name'],
                                              style: TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontSize:
                                                  18,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ) // child widget, replace with your own
                                      ),
                                      Container(
                                          width: double
                                              .infinity,
                                          margin: EdgeInsets
                                              .only(top: 3),
                                          decoration:
                                          BoxDecoration(),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left:
                                                8.0),
                                            child: Text(
                                              "Date    : "+ DateFormat('dd-MM-yyyy').format(doc['date'].toDate()).toString(),
                                              style: TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontSize:
                                                  14,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                          ) // child widget, replace with your own
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                          width: double
                                              .infinity,
                                          decoration:
                                          BoxDecoration(),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left:
                                                8.0),
                                            child: Text(
                                              "Time: " +
                                                  doc['time'],
                                              style: TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontSize:
                                                  14,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                          ) // child widget, replace with your own
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    left: 8,
                                    child: Text(
                                      "Status : Visited",
                                      style: TextStyle(
                                          color:
                                          Colors.white,
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ),);
                          ;
                        },
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class alertdialog extends StatelessWidget {
  var id;

  alertdialog({required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: Text(
                      'Are you sure you want to cancel this appointment?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                        ),


                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pending')
                                  .doc(id)
                                  .delete();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Image.asset('assets/images/logo1.jpg'),
                )),
          ),
        ],
      ),
    );
  }
}

class confirm extends StatelessWidget {
  var id;

  confirm({required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: Text(
                      'Are you sure you want to confirm this appointment?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                        ),

                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pending')
                                  .doc(id)
                                  .update({
                                'approve': true,
                              });
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Image.asset('assets/images/logo1.jpg'),
                )),
          ),
        ],
      ),
    );
  }

}
