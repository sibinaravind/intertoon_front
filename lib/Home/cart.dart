import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Models/models.dart';
import '../Utils/colors.dart';
import '../Utils/dimention.dart';
import '../functions/db_functions.dart';
import '../widgets/widgets.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  double delivery = 0;
  double total = 0;
  List<dynamic> listdata = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carttotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: EdgeInsets.only(top: 50, bottom: 25),
        padding: EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BigText(
                text: "Order Summary",
                size: 28,
                color: Colors.black,
              ),
              SizedBox(
                width: 110,
                child: Divider(
                  thickness: 4,
                  color: AppColors.mainGreenColor,
                ),
              ),
              CartDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget CartDisplay(BuildContext context) {
  Widget CartDisplay() {
    final SnackBar _snackBar = SnackBar(
      content: SmallText(
        text: "Order Placed",
        color: Colors.white,
        size: 15,
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.black,
    );
    return Container(
      child: ValueListenableBuilder(
          valueListenable: foodlistNotifier,
          builder: (BuildContext ctx, List<CartModel> cartlist, Widget? child) {
            total = 0;
            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cartlist.length + 1,
              itemBuilder: ((ctx, index) {
                // int count = item.qty;
                if (cartlist.length == 0) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 150, left: 10, right: 10),
                    child: Center(
                        child: Column(
                      children: [
                        SmallText(
                          text: "Your Cart is empty .. ",
                          color: Colors.grey,
                          size: 17,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SmallText(
                          text: "Find your favourites from  the menu ",
                          color: Colors.grey,
                          size: 17,
                        ),
                      ],
                    )),
                  );
                } else if (index < cartlist.length) {
                  CartModel item = cartlist[index];
                  total = total + item.price * item.qty;
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all()),
                          height: 40,
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    if (item.qty > 1) {
                                      final _cart = CartModel(
                                          keys: item.keys,
                                          id: item.id.toString(),
                                          name: item.name,
                                          price: item.price,
                                          qty: item.qty - 1);
                                      Updatecart(_cart);
                                    } else {
                                      Deletecart(item.keys!);
                                    }
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(7),
                                          bottomLeft: Radius.circular(7)),
                                    ),
                                    height: 40,
                                    width: 25,
                                    child: IconWidget(
                                      icon: Icons.remove,
                                      IconColor: AppColors.mainGreenColor,
                                    ),
                                  )),
                              SmallText(text: item.qty.toString()),
                              InkWell(
                                  onTap: () {
                                    final _cart = CartModel(
                                        keys: item.keys,
                                        id: item.id.toString(),
                                        name: item.name,
                                        price: item.price,
                                        qty: item.qty + 1);
                                    Updatecart(_cart);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(7),
                                          bottomRight: Radius.circular(7)),
                                    ),
                                    height: 40,
                                    width: 25,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: IconWidget(
                                        icon: Icons.add,
                                        IconColor: AppColors.mainGreenColor,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SmallText(
                            text: "X",
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(
                              text: item.name,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            SmallText(
                              text: '\u{20B9}${item.price}',
                              color: Colors.grey.shade700,
                            )
                          ],
                        )),
                        BigText(
                          text:
                              '\u{20B9}${(item.price * item.qty).toStringAsFixed(2)}',
                          size: 20,
                          color: AppColors.mainGreenColor,
                          fontWeight: FontWeight.w400,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            child: IconButton(
                              onPressed: () => {Deletecart(item.keys!)},
                              icon: IconWidget(
                                icon: Icons.delete,
                                size: 20,
                                IconColor: Colors.red.shade300,
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  );
                } else {
                  total == 0 ? delivery = 0 : delivery = 25;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: BigText(
                                  text: "Order",
                                  color: Colors.grey,
                                  size: 14,
                                  fontWeight: FontWeight.w400,
                                )),
                                SmallText(
                                  text: '\u{20B9}${total.toStringAsFixed(2)}',
                                  color: Colors.grey,
                                  size: 13,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: BigText(
                                  text: "Delivery",
                                  color: Colors.grey,
                                  size: 14,
                                  fontWeight: FontWeight.w400,
                                )),
                                SmallText(
                                  text: '\u{20B9}${delivery}',
                                  size: 13,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: BigText(
                                  text: "Total",
                                  size: 18,
                                  fontWeight: FontWeight.w600,
                                )),
                                BigText(
                                  text:
                                      '\u{20B9}${(delivery + total).toStringAsFixed(2)}',
                                  size: 28,
                                  fontWeight: FontWeight.w600,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      BigText(
                        text: "Address",
                        size: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: SmallText(
                            text: "Aikara House \nVellarikundu",
                            color: Colors.grey,
                            size: 13,
                          )),
                          SmallText(
                            text: "Change",
                            size: 13,
                            color: AppColors.mainGreenColor,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BigText(
                        text: "Payment",
                        size: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.payment_outlined,
                            color: Colors.black54,
                          ),
                          Expanded(
                              child: SmallText(
                            text: ".... .... .... 1410",
                            color: Colors.grey,
                            size: 13,
                          )),
                          SmallText(
                            text: "Change",
                            size: 13,
                            color: AppColors.mainGreenColor,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              carttotal = 0;
                            });
                            Deleteall();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(_snackBar);
                          },
                          child: Container(
                            width: Dimention.screenWidth / 1.3,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.mainGreenColor,
                            ),
                            child: const Center(
                              child: Text(
                                "Place Order",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
            );
          }),
    );
  }
}
