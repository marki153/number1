import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import '../Screens/detail_page.dart';

class SearchList extends StatefulWidget {
  final String searchKey;

  const SearchList({Key? key, required this.searchKey}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  TextEditingController _doctorName = TextEditingController();
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection('Sitter');
  var appointment = FirebaseFirestore.instance;
  var a='Mr  ';
  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  double rating = 0.0;

  get doc => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Sitter')
              .orderBy('name')
              .where('valid', isEqualTo: true)
              .startAt([widget.searchKey.toLowerCase()]).endAt(
              [widget.searchKey.toLowerCase() + '\uf8ff']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return snapshot.data!.size == 0
                ? Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No service provider found!',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/images/error-404.jpg'),
                            height: 250,
                            width: 250,
                          ),
                        ],
                      ),
                    ),
                  )
                : Scrollbar(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doctor = snapshot.data!.docs[index];
                        if (doctor['gender']=='female'){a='Ms.  ';}
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Card(
                            color: Colors.blue[100],
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 9,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        uid: doctor['uid'],
                                        name: doctor['name'],
                                        email: doctor['email'],
                                        address: doctor['address'],
                                        city: doctor['city'],
                                        experience: doctor['experience'],
                                        specialist: doctor['specialist'],
                                        profileImage: doctor['profileImage'],
                                        description: doctor['description'],
                                        phone: doctor['phone'],
                                        gender: doctor['gender'],
                                        available: doctor['available'],
                                        doctor: _doctorName,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    doctor['profileImage'] == false
                                        ? CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/account.png'),
                                            backgroundColor: Colors.transparent,
                                            radius: 25,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                doctor['profileImage']),
                                            backgroundColor: Colors.transparent,
                                            radius: 25,
                                          ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          a + doctor['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          doctor['specialist'] + ' Specialist',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Typicons.star_full_outline,
                                              size: 20,
                                              color: Colors.yellow[400],
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              doctor['rating'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          },
        ),
      ),
    );
  }
}
