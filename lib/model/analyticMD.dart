class Analytic {
  String success;
  AnalyticData data;

  Analytic({required this.success, required this.data});

  factory Analytic.fromJson(Map<String, dynamic> json) {
    return Analytic(
      success: json['success'],
      data: AnalyticData.fromJson(json['data']),
    );
  }
}

class AnalyticData {
  int totalPrice;
  int totalQuantity;
  int totalProducts;

  AnalyticData(
      {required this.totalPrice,
      required this.totalQuantity,
      required this.totalProducts});

  factory AnalyticData.fromJson(Map<String, dynamic> json) {
    return AnalyticData(
      totalPrice: json['total_price'],
      totalQuantity: json['total_quantity'],
      totalProducts: json['total_products'],
    );
  }
}
