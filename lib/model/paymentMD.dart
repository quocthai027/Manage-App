import 'package:flutter_application_21/model/userMD.dart';

class Payment {
  int id;
  int userId;
  String recipientName;
  String address;
  int phone;
  String? note;
  String receiveDate;
  String totalPrice;
  int status;
  String paymentStatus;
  List<CartPayment> carts;
  UserDataPayment users;

  Payment(
      {required this.id,
      required this.userId,
      required this.recipientName,
      required this.address,
      required this.phone,
      this.note,
      required this.receiveDate,
      required this.totalPrice,
      required this.status,
      required this.paymentStatus,
      required this.carts,
      required this.users});

  factory Payment.fromJson(Map<String, dynamic> json) {
    var cartList = json['carts'] as List;
    List<CartPayment> carts =
        cartList.map((item) => CartPayment.fromJson(item)).toList();
//  var userList = json['user'] as List;
//     List<UserData> users =
//         userList.map((item) => UserData.fromJson(item)).toList();
    return Payment(
      id: json['id'],
      userId: json['user_id'],
      recipientName: json['recipient_name'],
      address: json['address'],
      phone: json['phone'],
      note: json['note'],
      receiveDate: json['receive_date'],
      totalPrice: json['total_price'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      carts: carts,
      users: UserDataPayment.fromJson(json['user']),
    );
  }
}

class CartPayment {
  int id;
  int productId;
  int variantId;
  int quantity;
  double price;
  int paymentId;
  int userId;
  ProductPayment product;
  VariantPayment variant;

  CartPayment({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.price,
    required this.paymentId,
    required this.userId,
    required this.product,
    required this.variant,
  });

  factory CartPayment.fromJson(Map<String, dynamic> json) {
    return CartPayment(
      id: json['id'],
      productId: json['product_id'],
      variantId: json['variant_id'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      paymentId: json['payment_id'],
      userId: json['user_id'],
      product: ProductPayment.fromJson(json['product']),
      variant: VariantPayment.fromJson(json['variant']),
    );
  }
}

class ProductPayment {
  int id;
  String name;
  String description;
  double price;
  int categoryId;
  int views;
  List<ImagePayment> images;

  ProductPayment({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.views,
    required this.images,
  });

  factory ProductPayment.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List;
    List<ImagePayment> images =
        imageList.map((item) => ImagePayment.fromJson(item)).toList();

    return ProductPayment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      categoryId: json['category_id'],
      views: json['views'],
      images: images,
    );
  }
}

class VariantPayment {
  int id;
  int productId;
  String color;
  String size;
  int quantity;

  VariantPayment({
    required this.id,
    required this.productId,
    required this.color,
    required this.size,
    required this.quantity,
  });

  factory VariantPayment.fromJson(Map<String, dynamic> json) {
    return VariantPayment(
      id: json['id'],
      productId: json['product_id'],
      color: json['color'],
      size: json['size'],
      quantity: json['quantity'],
    );
  }
}

class ImagePayment {
  int id;
  int productId;
  String image;
  String imagePath;

  ImagePayment({
    required this.id,
    required this.productId,
    required this.image,
    required this.imagePath,
  });

  factory ImagePayment.fromJson(Map<String, dynamic> json) {
    return ImagePayment(
      id: json['id'],
      productId: json['product_id'],
      image: json['image'],
      imagePath: json['image_path'],
    );
  }
}
