class Food {
  final String id;
  final String sku;
  final String name;
  final String description;
  final String image;
  final int price;
  final int special_price;
  final String available_from;
  final String available_to;
  final int is_veg;
  final String variations;

  const Food({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.special_price,
    required this.available_from,
    required this.available_to,
    required this.is_veg,
    required this.variations,
  });
}
