import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intertoons/functions/db_functions.dart';
import '../Models/food_model.dart';
import '../Models/models.dart';
import '../Utils/utils.dart';
import '../networkHandler.dart';
import '../widgets/widgets.dart';
import 'package:logger/logger.dart';
import 'package:flutter/gestures.dart';
import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  late ScrollController _scrollControl = ScrollController();
  var log = new Logger();
  var current_page = 1;
  var total_item = 0;
  var last = false;

  List<dynamic> listdata = [];
  @override
  void initState() {
    super.initState();
    fetchMass();
    _scrollControl.addListener(() {
      if (_scrollControl.position.maxScrollExtent ==
          _scrollControl.position.pixels) {
        fetchMass();
      }
    });
  }

  @override
  void dispose() {
    _scrollControl.dispose();
    super.dispose();
  }

  Future fetchMass() async {
    Map<String, dynamic> data = {
      "currentpage": current_page,
      "pagesize": 10,
      "sortorder": {"field": "menu_name", "direction": "desc"},
      "searchstring": "",
      "filter": {"category": ""}
    };
    var response = await networkHandler.post2("/products", data);
    // log.i(response["data"]);
    setState(() {
      current_page++;
      // log.i(response["data"]["products"]);
      listdata.addAll(response["data"]["products"]);
      total_item = response["data"]["total"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 45),
        padding: EdgeInsets.only(left: 5, right: 5),
        child: CustomScrollView(
          controller: _scrollControl,
          slivers: [
            SliverToBoxAdapter(
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
                      ..onTap = () => print("hello")),
              ])),
            ),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                sliver: SliverToBoxAdapter(child: FoodPageBody())),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    // margin: EdgeInsets.only(left: Dimention.width30),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                )),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(3.5, 5.0, 0.0, 5.0),
              sliver: SliverList(
                delegate: listdata.length > 0
                    ? SliverChildBuilderDelegate(
                        childCount: listdata.length + 1,
                        (context, index) {
                          if (index < listdata.length) {
                            final item = listdata[index];

                            return Container(
                              // margin: EdgeInsets.only(
                              //     left: Dimention.width30, right: Dimention.width30),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 4),
                                    child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade800,
                                                  blurRadius: 2.0)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: item["image"] != null
                                                    ? networkHandler
                                                        .getImage(item["image"])
                                                    : networkHandler.getImage(
                                                        "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg")))),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FoodDetails(
                                                  id: item["id"].toString(),
                                                  name: item["name"],
                                                  discription:
                                                      item["description"],
                                                  veg: item["is_veg"],
                                                  price: item["price"],
                                                  url: item["image"] == null
                                                      ? "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg"
                                                      : item["image"],
                                                )),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 1),
                                      child: Container(
                                        height: 100,
                                        width: Dimention.screenWidth / 1.65,
                                        decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 2.0)
                                            ],
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // textDirection: text,
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        item["is_veg"] == "1"
                                                            ? VeganIcon()
                                                            : SizedBox.shrink(),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Flexible(
                                                          child: BigText(
                                                            text: item["name"],
                                                            size: 15.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SmallText(
                                                      text: item["description"],
                                                      color: Colors.grey,
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 1.5,
                                                          bottom: 1.5),
                                                      child: Divider(
                                                          thickness: 1.5),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: SmallText(
                                                          text:
                                                              "\u{20B9}${item["price"]}",
                                                          size: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                final _cart = CartModel(
                                                    id: item["id"].toString(),
                                                    name: item["name"],
                                                    price: double.parse(
                                                        item["price"]),
                                                    qty: 1);

                                                AddToCart(_cart);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(_snackBar);
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: 100,
                                                  width:
                                                      Dimention.screenWidth / 8,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10),
                                                    ),
                                                    color: AppColors.mainColor,
                                                  ),
                                                  child: const Text(
                                                      "Add To Cart",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        // fontFamily: 'Raleway',
                                                        color: Color.fromARGB(
                                                            255, 51, 124, 53),
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ))),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            if (listdata.length >= total_item &&
                                total_item != 0) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Center(
                                    child: SmallText(
                                  text: "no more items to print ",
                                  size: 12,
                                  color: Colors.grey,
                                )),
                              );
                            } else {
                              // fetchMass();
                              return const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CupertinoActivityIndicator(
                                    color: Color.fromARGB(255, 51, 124, 53),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      )
                    : SliverChildBuilderDelegate(childCount: 1,
                        (context, index) {
                        return const Center(
                          child: SizedBox(
                            height: 10,
                            child: CupertinoActivityIndicator(
                              color: Color.fromARGB(255, 51, 124, 53),
                            ),
                          ),
                        );
                      }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
