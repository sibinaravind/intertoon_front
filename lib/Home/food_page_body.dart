import '../Utils/colors.dart';
import '../Utils/dimention.dart';
import 'package:flutter/cupertino.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);
  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimention.screenHeight / 3.5,
        width: Dimention.screenWidth,
        margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/image_dis.jpg"))));
  }
}
