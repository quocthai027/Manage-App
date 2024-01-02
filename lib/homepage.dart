import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_21/paymentPage.dart';
import 'package:flutter_application_21/productpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analyticPage.dart';
import 'analyticPage2.dart';
import 'loginPage.dart';
import 'userPage.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  String name = '';
  final List<Widget> _pages = [
    ProductListScreen(),
    UserListScreen(),
    PaymentDetailsScreen(),
    Ana2(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Ẩn nút quay lại
        backgroundColor:
            Colors.transparent, // Đặt màu nền trong suốt cho AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: RichText(
            maxLines: 1, // Giới hạn chỉ 2 dòng
            overflow:
                TextOverflow.ellipsis, // Thêm dấu "..." nếu văn bản dài hơn
            text: TextSpan(
              text: 'Tài khoản $name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            )),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.black54, // text + icon color
            ),
            icon: Icon(Icons.logout, size: 20),
            label: Text('Logout', style: TextStyle(fontSize: 14)),
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.clear();
              // log('message${pref}');
              // Logout();
              print('ds');
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                'Đăng xuất thành công',
                style: TextStyle(fontWeight: FontWeight.bold),
              )));
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar:
          // CurvedNavigationBar(
          //   // color: Colors.white,
          //   // buttonBackgroundColor: Colors.white,
          //   // //  height: 50,
          //   // animationDuration: Duration(milliseconds: 200),
          //   index: _currentIndex,
          //   onTap: (index) {
          //     setState(() {
          //       _currentIndex = index;
          //     });
          //   },
          //   items: [
          //     Icon(
          //       Icons.work_rounded,
          //       size: 30,
          //       color: Colors.grey,
          //     ),
          //     Icon(
          //       Icons.supervised_user_circle,
          //       size: 30,
          //       color: Colors.grey,
          //     ),
          //     Icon(
          //       Icons.shopping_bag_outlined,
          //       size: 30,
          //       color: Colors.grey,
          //     ),
          //     Icon(
          //       Icons.analytics_outlined,
          //       size: 30,
          //       color: Colors.grey,
          //     ),
          //   ],
          // ),
          BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.blueGrey,
            icon: Icon(
              Icons.work_rounded,
              color: Colors.grey,
            ),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervised_user_circle,
              color: Colors.grey,
            ),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.grey,
            ),
            label: 'Đơn Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.analytics_outlined,
              color: Colors.grey,
            ),
            label: 'Thống kê',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? valname = pref.getString('hello');
    setState(() {
      name = valname ?? '';
    });
  }
}
