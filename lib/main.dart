import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';

import 'loginPage.dart';
import 'model/ipinfo.dart';
import 'model/modelcheck.dart';
import 'widgettama.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manage App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<dynamic>>(
        future: Future.wait([fetchData(), fetchIPInfo()]),
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final appSettings = snapshot.data?[0] as AppSettings;
            final ipInfo = snapshot.data?[1] as IPInfo;
            print(ipInfo.country);
            print(appSettings.appVersion);
            if (appSettings.appVersion == '0') {
              if (ipInfo.country != 'VN') {
                return Splash();
              } else {
                return MyWidget();
              }
            } else {
              return Splash(); 
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi: ${snapshot.error}'),
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<IPInfo> fetchIPInfo() async {
    final response = await http.get(Uri.parse('https://ipinfo.io/json'));

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      print('oke');
      return IPInfo.fromJson(jsonMap);
    } else {
      throw Exception('Không thể lấy thông tin IP.');
    }
  }

  Future<AppSettings> fetchData() async {
    final String url = 'http://45.32.19.162/apithai/get_setting.php';
    final Map<String, String> data = {
      'secret_key': '0A83425hWdn#@^I6ccrgo19Y',
    };

    final response = await http.post(
      Uri.parse(url),
      body: data,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final appSettings = AppSettings.fromJson(jsonResponse);
      print(appSettings);
      return appSettings;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    Flashcheck();
  }

  Flashcheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = await pref.getString('login');
    String? valname = await pref.getString('hello');
    Future.delayed(const Duration(seconds: 3), () {
      if (val == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        // BlocProvider<DetailNativeBloc>(
//         create: (context) => DetailNativeBloc()..add(GetproductEvent()),
//         child: Builder(
//           builder: (context) {
//             return const Splash();
//           }
//         ),
//       ),
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Chào mừng bạn đã trở lại')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: LottieBuilder.network(
                    'https://lottie.host/7b0dbd8b-b546-4345-8825-4acaf697a45d/JbK7WV83Pu.json'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
