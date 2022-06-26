import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:intertoons/Models/food_model.dart';
import 'package:intertoons/Models/models.dart';

ValueNotifier<List<CartModel>> foodlistNotifier = ValueNotifier([]);
double carttotal = 0;

Future<void> AddToCart(CartModel value) async {
  final Cartdb = await Hive.openBox<CartModel>('Cart_db');
  final userToUpdate = await Cartdb.values.where((element) {
    return element.id.contains(value.id);
  }).toList();
  if (userToUpdate.length == 0) {
    int _id = await Cartdb.add(value);
    value.keys = _id;
  } else {
    value.qty = userToUpdate[0].qty + value.qty;
    final index = userToUpdate[0].keys;
    value.keys = index;
    await Cartdb.put(index, value);
  }
  GetCart();
}

Future<void> GetCart() async {
  final Cartdb = await Hive.openBox<CartModel>('Cart_db');
  foodlistNotifier.value.clear();
  Cartdb.values.toList();
  foodlistNotifier.value.addAll(Cartdb.values);
  foodlistNotifier.notifyListeners();
}

Future<void> Deletecart(int keys) async {
  final Cartdb = await Hive.openBox<CartModel>('Cart_db');
  await Cartdb.delete(keys);
  GetCart();
  foodlistNotifier.notifyListeners();
}

Future<void> Deleteall() async {
  final Cartdb = await Hive.openBox<CartModel>('Cart_db');
  foodlistNotifier.value.clear();
  Cartdb.clear();
  foodlistNotifier.notifyListeners();
}

Future<void> Updatecart(CartModel value) async {
  final Cartdb = await Hive.openBox<CartModel>('Cart_db');
  final index = value.keys;
  await Cartdb.put(index, value);
  GetCart();
}
