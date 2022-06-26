import 'package:hive/hive.dart';
part 'cart_model.g.dart';

@HiveType(typeId: 1)
class CartModel {
  @HiveField(0)
  int? keys;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final double price;
  @HiveField(4)
  late int qty;

  CartModel({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    this.keys,
  });
}
