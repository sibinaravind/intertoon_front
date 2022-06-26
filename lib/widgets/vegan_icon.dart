import 'package:flutter/material.dart';

class VeganIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.crop_square_sharp,
          color: Colors.green,
          size: 19,
        ),
        Icon(
          Icons.circle,
          color: Colors.green,
          size: 9,
        ),
      ],
    );
  }
}
