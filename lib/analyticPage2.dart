import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/analyticMD2.dart';

class ChartData {
  final String date;
  final int totalPrice;
  final charts.Color barColor;

  ChartData(
      {required this.date, required this.totalPrice, required this.barColor});
}

class ChartWidget extends StatelessWidget {
  //chartDataList: Một danh sách các đối tượng ChartData chứa dữ liệu cho biểu đồ.
  final List<ChartData> chartDataList;
  final double height;

  ChartWidget({required this.chartDataList, this.height = 300});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartData, String>> seriesList = [
      charts.Series(
        id: 'Total Price',
        data: chartDataList,
        //dữ liệu trục x
        domainFn: (ChartData data, _) => data.date,
        //dữ liệu trục y
        measureFn: (ChartData data, _) => data.totalPrice,
        colorFn: (ChartData data, _) => data.barColor,
      ),
    ];

    return Container(
      height: height,
      child: charts.BarChart(
        seriesList,
        //cho phép hiệu ứng hoạt hình khi vẽ biểu đồ.
        animate: true,
        //hiển thị biểu đồ chiều ngang
        vertical: false,
      ),
    );
  }
}

class Ana2 extends StatefulWidget {
  @override
  _Ana2State createState() => _Ana2State();
}

class _Ana2State extends State<Ana2> {
  List<ChartData> chartDataList = [];
  int totalPrice = 0;
  int totalQuantity = 0;
  int totalProducts = 0;

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  final dateFormatter = DateFormat('dd/MM/yyyy');
  @override
  void initState() {
    super.initState();

    fetchData2().then((data) {
      setState(() {
        chartDataList = data;
      });
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: chartDataList.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ChartWidget(
                      chartDataList: chartDataList,
                      height: 490,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tổng tiền bán được: $totalPrice\$',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Số lượng trong tất cả sản phẩm: $totalQuantity',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Số lượng sản phẩm: $totalProducts',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Từ ngày: ${dateFormatter.format(fromDate)}',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Đến ngày: ${dateFormatter.format(toDate)}',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.blue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            onPressed: () => _selectFromDate(context),
                            child: Text(
                              'Chọn ngày bắt đầu',
                              style: TextStyle(fontSize: 13),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.blue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            onPressed: () => _selectToDate(context),
                            child: Text(
                              'Chọn ngày kết thúc',
                              style: TextStyle(fontSize: 13),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<List<ChartData>> fetchData2() async {
    var headers = {'Cookie': 'PHPSESSID=sninv949sjhdmvftl5t9otvk85'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://45.32.19.162/shopping-api/analytic/list.php?from_date=${fromDate.toIso8601String()}&to_date=${toDate.toIso8601String()}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseString);

      final analyticResponse = AnalyticResponse2.fromJson(jsonData);
      final dataMap = analyticResponse.data;

      final List<ChartData> chartDataList = [];
//lặp qua từng cặp khóa-giá trị trong dataMap. Mỗi cặp đại diện cho một ngày và dữ liệu tiền
      dataMap.forEach((date, analyticData) {
        final chartData = ChartData(
          date: date,
          totalPrice: analyticData.totalPrice,
          barColor: charts.MaterialPalette.blue.shadeDefault,
        );
        chartDataList.add(chartData);
      });

      return chartDataList;
    } else {
      print(response.reasonPhrase);
      return [];
    }
  }

  Future<void> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token2 = pref.getString('login');
    var headers = {
      'Cookie': 'PHPSESSID=uggp81o24vjnqueb6aq78p6sgl',
    };
    var request = http.Request(
      'GET',
      Uri.parse(
        'http://45.32.19.162/shopping-api/analytic/get.php?from_date=${fromDate.toIso8601String()}&to_date=${toDate.toIso8601String()}',
      ),
    );
    request.headers.addAll({
      'Authorization': 'Bearer $token2',
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonResponse = await response.stream.bytesToString();
      Map<String, dynamic> json = jsonDecode(jsonResponse);

      setState(() {
        totalPrice = json['data']['total_price'];
        totalQuantity = json['data']['total_quantity'];
        totalProducts = json['data']['total_products'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
      fetchData2().then((data) {
        setState(() {
          chartDataList = data;
        });
      });
      fetchData();
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
      fetchData2().then((data) {
        setState(() {
          chartDataList = data;
        });
      });
      fetchData();
    }
  }
}
