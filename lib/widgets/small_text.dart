import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;
  TextOverflow overFlow;
  TextDecoration textDecoration;
  int maxlines;
  SmallText(
      {Key? key,
      this.maxlines = 2,
      this.color = const Color(0xFF332d2b),
      required this.text,
      this.height = 1.2,
      this.overFlow = TextOverflow.ellipsis,
      this.size = 11,
      this.textDecoration = TextDecoration.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxlines,
        overflow: overFlow,
        textAlign: TextAlign.justify,
        style: TextStyle(
          decoration: textDecoration,
          fontFamily: 'Roboto',
          color: color,
          fontSize: size,
          height: height,
          fontWeight: FontWeight.w500,
        ));
  }
}
