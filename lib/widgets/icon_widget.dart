import './widgets.dart';
import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  Color IconColor;
  double size;
  IconWidget(
      {super.key,
      this.size = 20,
      required this.icon,
      this.IconColor = const Color(0xFF332d2b)});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          size: size,
          icon,
          color: IconColor,
        ),
      ],
    );
  }
}
