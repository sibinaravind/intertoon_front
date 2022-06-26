import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
        ),
        CircleAvatar(
          radius: 13.5,
          backgroundColor: Colors.black38,
        ),
        Padding(
          padding: EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close,
            color: Colors.black,
            size: 22,
          ),
        ),
      ],
    );
  }
}
