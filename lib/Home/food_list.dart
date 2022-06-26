import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intertoons/functions/db_functions.dart';
import '../Models/food_model.dart';
import '../Models/models.dart';
import '../Utils/utils.dart';
import '../networkHandler.dart';
import '../widgets/widgets.dart';
import 'package:logger/logger.dart';

class FoodListingPage extends StatefulWidget {
  const FoodListingPage({Key? key}) : super(key: key);

  @override
  State<FoodListingPage> createState() => _FoodListingPageState();
}

class _FoodListingPageState extends State<FoodListingPage> {
  final SnackBar _snackBar = SnackBar(
    content: SmallText(
      text: "Item Added to the Cart",
      color: Colors.white,
      size: 15,
    ),
    duration: const Duration(seconds: 3),
    backgroundColor: Color.fromARGB(255, 51, 124, 53),
  );
  NetworkHandler networkHandler = NetworkHandler();
  late ScrollController _scrollControl = ScrollController();
  var log = new Logger();
  var current_page = 1;
  var total_item = 0;
  List<dynamic> listdata = [];

  @override
  void initState() {
    super.initState();
    fetchMass();
    _scrollControl.addListener(() {
      if (_scrollControl.position.maxScrollExtent == _scrollControl.offset) {
        log.i("hello");
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
      body: ListView.builder(
          controller: _scrollControl,
          padding: const EdgeInsets.all(0.5),
          primary: false,
          // physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: listdata.length + 1,
          itemBuilder: (context, index) {
            if (index < listdata.length) {
              final item = listdata[index];
              return Container(
                // margin: EdgeInsets.only(
                //     left: Dimention.width30, right: Dimention.width30),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, top: 4),
                      child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade800,
                                    blurRadius: 2.0)
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: item["image"] != null
                                      ? networkHandler.getImage(item["image"])
                                      : networkHandler.getImage(
                                          "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg")))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: Container(
                        height: 100,
                        width: Dimention.screenWidth / 1.65,
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 2.0)
                            ],
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Color.fromARGB(255, 255, 255, 255)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      print("Hello");
                                    },
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
                                              top: 1.5, bottom: 1.5),
                                          child: Divider(thickness: 1.5),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: SmallText(
                                              text: "\u{20B9}${item["price"]}",
                                              size: 14),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final _cart = CartModel(
                                    id: item["id"].toString(),
                                    name: item["name"],
                                    price: double.parse(item["price"]),
                                    qty: 1);

                                AddToCart(_cart);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(_snackBar);
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: Dimention.screenWidth / 8,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: AppColors.mainColor,
                                  ),
                                  child: const Text("Add To Cart",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        // fontFamily: 'Raleway',
                                        color: Color.fromARGB(255, 51, 124, 53),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              if (listdata.length >= total_item && total_item != 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Center(
                      child: SmallText(
                    text: "no more items to print ",
                    size: 12,
                    color: Colors.grey,
                  )),
                );
              } else {
                fetchMass();
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: Color.fromARGB(255, 51, 124, 53),
                  ),
                );
              }
            }
          }),
    );
  }
}
