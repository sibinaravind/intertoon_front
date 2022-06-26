import 'package:flutter/gestures.dart';
import '../Utils/colors.dart';
import 'package:flutter/material.dart';
import '../Utils/dimention.dart';
import '../widgets/widgets.dart';
import 'home.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  // const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 45),
        padding: EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SingleChildScrollView(
                reverse: true,
                child: SelectableText.rich(TextSpan(children: [
                  WidgetSpan(
                    // width: Dimention.screenWidth,
                    child: Text("What you wish to get delivered on ",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          // inherit: true,
                          color: AppColors.textColor,
                          fontFamily: 'Roboto',
                          fontSize: Dimention.tagsize,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  TextSpan(
                      text: "Edapally?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 51, 124, 53),
                        fontFamily: 'Roboto',
                        fontSize: Dimention.tagsize,
                        fontWeight: FontWeight.w900,
                      ),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => print(Get.context!.width)),
                ])),
              ),
              const SizedBox(
                height: 10,
              ),
              FoodPageBody(),
              const SizedBox(
                height: 10,
              ),
              Container(
                // margin: EdgeInsets.only(left: Dimention.width30),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  BigText(
                    text: "Recommended",
                    size: Dimention.tagsize,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: BigText(
                      text: ".",
                      color: AppColors.smallText,
                      size: Dimention.tagsize,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SmallText(
                    text: "Food Pairing",
                    color: AppColors.smallText,
                    size: Dimention.tagsize / 1.5,
                  ),
                ]),
              ),
              FoodListingPage(),
            ],
          ),
        ),
      ),
    );
  }
}
