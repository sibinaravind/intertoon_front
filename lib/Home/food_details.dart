import 'package:flutter/material.dart';
import '../Models/models.dart';
import '../Utils/utils.dart';
import '../functions/db_functions.dart';
import '../networkHandler.dart';
import '../widgets/widgets.dart';
import 'package:logger/logger.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails(
      {Key? key,
      required this.id,
      required this.name,
      required this.discription,
      required this.url,
      required this.veg,
      required this.price})
      : super(key: key);
  final String id;
  final String name;
  final String veg;
  final String discription;
  final String url;
  final String price;

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  final SnackBar _snackBar = SnackBar(
    content: SmallText(
      text: "Item Added to the Cart",
      color: Colors.white,
      size: 15,
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: Color.fromARGB(255, 51, 124, 53),
  );
  NetworkHandler networkHandler = NetworkHandler();
  var count = ValueNotifier(1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Stack(children: [
        Container(
            height: Dimention.screenHeight / 2.5,
            width: Dimention.screenWidth,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: widget.url != null
                        ? networkHandler.getImage(widget.url)
                        : networkHandler.getImage(
                            "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg")))),
        Positioned(
          top: 45,
          left: 15,
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: RoundedIcon()),
        ),
      ]),
      Expanded(
        child: Container(
          height: Dimention.screenHeight / 3.5,
          width: Dimention.screenWidth,
          margin: const EdgeInsets.only(left: 8, right: 5, top: 15),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // textDirection: text,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BigText(
                        text: widget.name,
                        size: 30,
                      ),
                    ),
                    widget.veg == "1" ? VeganIcon() : SizedBox.shrink(),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SmallText(
                  text: widget.discription,
                  color: Colors.grey,
                  size: 15,
                  maxlines: 20,
                )
              ],
            ),
          ]),
        ),
      ),
      Container(
        height: Dimention.screenHeight / 12,
        width: Dimention.screenWidth,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all()),
                height: 40,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          if (count.value != 1) {
                            count.value--;
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            // color: Colors.white10,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7)),
                          ),
                          height: 40,
                          width: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: IconWidget(
                              icon: Icons.remove,
                              size: 30,
                              IconColor: AppColors.mainGreenColor,
                            ),
                          ),
                        )),
                    ValueListenableBuilder(
                        valueListenable: count,
                        builder: (context, value, child) {
                          return SmallText(
                            text: value.toString(),
                            size: 15,
                          );
                        }),
                    InkWell(
                        onTap: () {
                          count.value++;
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            // color: Color.fromARGB(255, 189, 189, 189),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(7),
                                bottomRight: Radius.circular(7)),
                          ),
                          height: 40,
                          width: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: IconWidget(
                              icon: Icons.add,
                              size: 30,
                              IconColor: AppColors.mainGreenColor,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: count,
                  builder: (context, int value, child) {
                    return BigText(
                      text:
                          '\u{20B9}${(double.parse(widget.price) * value).toStringAsFixed(2)}',
                      size: 22,
                      color: AppColors.mainGreenColor,
                      fontWeight: FontWeight.w700,
                    );
                  }),
              InkWell(
                onTap: () async {
                  final _cart = CartModel(
                      id: widget.id.toString(),
                      name: widget.name,
                      price: double.parse(widget.price),
                      qty: count.value);
                  AddToCart(_cart);

                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.mainGreenColor,
                  ),
                  child: const Center(
                    child: Text(
                      "Add To cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ]));
  }
}
