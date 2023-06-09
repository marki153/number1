import 'package:flutter/material.dart';
import '../constants.dart';

class HDCell extends StatefulWidget {
  final valid;
  final name;
  final email;
  final gender;
  final specialist;
  final profileImage;
  final Function onTap;

  const HDCell({
    required this.valid,
    required this.name,
    required this.email,
    required this.gender,
    required this.specialist,
    required this.onTap,
    required this.profileImage,
  });


  @override
  State<HDCell> createState() => _HDCellState();
}

class _HDCellState extends State<HDCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        width: 283,
        height: 150,
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color:Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: SizedBox(
                width: 162,
                height: 139,
                child: Image(
                  image: AssetImage('assets/images/bg_shape.png'),
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.gender == 'female' ? 'Ms.  ' : 'Mrs.  '),
                    style: TextStyle(
                      color: Color(0xFF151313),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Color(0xFF151313),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.specialist ,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 77,
                height: 54,
                decoration: BoxDecoration(
                  color: Color(0xFF4CA6A8),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(32)),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 10,
              bottom: 10,
              child: Container(
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor:Color(0xFF4CA6A8),
                  child: widget.profileImage == false
                      ? CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/account.png'),
                  )
                      : CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.profileImage),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
