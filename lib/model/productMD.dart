class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final List<String> images;
  final List<Map<String, dynamic>> variants;
  late final int views;
  final int categoryid;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.variants,
    required this.views,
    required this.categoryid,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      images: List<String>.from(json['images_list']),
      variants: List<Map<String, dynamic>>.from(json['variants']),
      views: json['views'],
      categoryid: json['category_id'],
    );
  }
}
