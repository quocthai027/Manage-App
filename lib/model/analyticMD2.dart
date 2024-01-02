class AnalyticResponse2 {
  final String success;
  final Map<String, AnalyticData2> data;

  AnalyticResponse2({required this.success, required this.data});

  factory AnalyticResponse2.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> dataJson = json['data'];
    final Map<String, AnalyticData2> data = dataJson
        .map((key, value) => MapEntry(key, AnalyticData2.fromJson(value)));

    return AnalyticResponse2(
      success: json['success'],
      data: data,
    );
  }
}

class AnalyticData2 {
  final int totalPrice;
  final int totalQuantity;
  final int totalProducts;

  AnalyticData2(
      {required this.totalPrice,
      required this.totalQuantity,
      required this.totalProducts});

  factory AnalyticData2.fromJson(Map<String, dynamic> json) {
    return AnalyticData2(
      totalPrice: json['total_price'],
      totalQuantity: json['total_quantity'],
      totalProducts: json['total_products'],
    );
  }
}