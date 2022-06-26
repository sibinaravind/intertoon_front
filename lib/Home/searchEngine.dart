import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/models.dart';
import '../Utils/utils.dart';
import '../functions/db_functions.dart';
import '../networkHandler.dart';
import '../widgets/widgets.dart';
import 'home.dart';

class SearchEngine extends StatefulWidget {
  @override
  _SearchEngineState createState() => _SearchEngineState();
}

class _SearchEngineState extends State<SearchEngine> {
  bool firstClick = true;
  bool circular = false;
  String dis = "Search your Favourites";
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> listdata = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Row(
            children: [
              Expanded(child: foodSearch()),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (firstClick) {
                    setState(() {
                      listdata = [];
                      circular = true;
                      firstClick = false;
                    });
                    Map<String, dynamic> data = {
                      "currentpage": 1,
                      "pagesize": 25,
                      "sortorder": {"field": "menu_name", "direction": "desc"},
                      "searchstring": _searchController.text,
                      "filter": {"category": ""}
                    };
                    var response =
                        await networkHandler.post2("/products", data);
                    // print(response["data"]["products"]);
                    if (response["data"]["total"] != 0) {
                      setState(() {
                        listdata = response["data"]["products"];
                        circular = false;
                        firstClick = true;
                      });
                    } else {
                      setState(() {
                        dis = "Sorry, we are not delivering search item";
                        circular = false;
                        firstClick = true;
                      });
                    }
                  }
                },
                child: Center(
                  child: Container(
                    width: Dimention.screenWidth / 4.5,
                    height: Dimention.screenWidth / 7.5,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 51, 124, 53),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: circular
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.mainColor,
                              ))
                          : const Text("Search",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3.5,
          ),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(
            height: 3.5,
          ),
          // SmallText(text: dis),
          listdata.length == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SmallText(text: dis, size: 13, color: Colors.grey),
                  ))
              : searchDisplay()
        ],
      ),
    ));
  }

  Widget searchDisplay() {
    final SnackBar _snackBar = SnackBar(
      content: SmallText(
        text: "Item Added to the Cart",
        color: Colors.white,
        size: 15,
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: Color.fromARGB(255, 51, 124, 53),
    );
    return ListView.builder(
        padding: const EdgeInsets.all(0.5),
        // primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listdata.length,
        itemBuilder: (context, index) {
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
                                color: Colors.grey.shade800, blurRadius: 2.0)
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FoodDetails(
                                  id: item["id"].toString(),
                                  name: item["name"],
                                  discription: item["description"],
                                  veg: item["is_veg"],
                                  price: item["price"],
                                  url: item["image"] == null
                                      ? "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg"
                                      : item["image"],
                                )));
                  },
                  child: Padding(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    padding:
                                        EdgeInsets.only(top: 1.5, bottom: 1.5),
                                    child: Divider(thickness: 1.5),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SmallText(
                                        text: "\u{20B9}${item["price"]}",
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
                                  price: double.parse(item["price"]),
                                  qty: 1);
                              AddToCart(_cart);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_snackBar);
                              // final _cart = CartModel(
                              //     id: "id", name: "name", price: 5, qty: 5);
                              // AddCart(_cart);
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
                ),
              ],
            ),
          );
        });
  }

  Widget foodSearch() {
    return SizedBox(
      height: Dimention.screenHeight / 15,
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
            focusColor: Color.fromARGB(255, 51, 124, 53),
            labelText: "Search Food",
            hintText: "Search Your Favourite",
            labelStyle: TextStyle(color: Color.fromARGB(255, 51, 124, 53)),
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 51, 124, 53),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 51, 124, 53), width: 2)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }
}
