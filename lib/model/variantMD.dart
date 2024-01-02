class Variant {
  int id;
  int productId;
  String color;
  String size;
  int quantity;

  Variant({
    required this.id,
    required this.productId,
    required this.color,
    required this.size,
    required this.quantity,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      productId: json['product_id'],
      color: json['color'],
      size: json['size'],
      quantity: json['quantity'],
    );
  }
}
