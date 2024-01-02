// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'loginthangcong.dart';
// import 'model/user.dart';

// void main() => runApp(MaterialApp(home: LoginPage()));

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   final formKey = GlobalKey<FormState>();
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool showPassword = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 5),
//     );

//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           LottieBuilder.network(
//             'https://assets9.lottiefiles.com/packages/lf20_jcikwtux.json',
//             fit: BoxFit.cover,
//           ),
//           Container(
//             padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
//             child: FadeTransition(
//               opacity: _animation,
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Đăng nhập ADMIN',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.purple,
//                         letterSpacing: 1.5,
//                         shadows: [
//                           Shadow(
//                             color: Colors.black,
//                             blurRadius: 2,
//                             offset: Offset(1, 1),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       controller: usernameController,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Email không được bỏ trống';
//                         }
//                       },
//                       decoration: InputDecoration(
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.purple),
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.purple),
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         prefixIcon: Icon(
//                           Icons.person,
//                           color: Colors.purple,
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                         labelText: "Email",
//                         hintText: 'username@gmail.com',
//                         labelStyle: TextStyle(color: Colors.purple),
//                       ),
//                     ),
//                     SizedBox(height: 10.0),
//                     TextFormField(
//                       controller: passwordController,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Mật khẩu không được bỏ trống";
//                         }
//                       },
//                       obscuringCharacter: '*',
//                       obscureText:
//                           !showPassword, // Set obscureText based on showPassword flag
//                       decoration: InputDecoration(
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.purple),
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.purple),
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         prefixIcon: Icon(
//                           Icons.lock,
//                           color: Colors.purple,
//                         ),
//                         suffixIcon: IconButton(
//                           // Add suffix icon button to toggle show/hide password
//                           onPressed: () {
//                             setState(() {
//                               showPassword = !showPassword;
//                             });
//                           },
//                           icon: Icon(
//                             // Show eye icon if password is obscured, otherwise show eye slash icon
//                             showPassword
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                         labelText: "Password",
//                         hintText: '*********',
//                         labelStyle: TextStyle(color: Colors.purple),
//                       ),
//                     ),
//                     SizedBox(height: 20.0),
//                     InkWell(
//                       onTap: () async {
//                         if (formKey.currentState!.validate()) {
//                           Login();
//                         }
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: EdgeInsets.symmetric(vertical: 15),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.purple,
//                               Colors.orange,
//                             ],
//                           ),
//                         ),
//                         child: Text(
//                           'Login',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> Login() async {
//     final dio = Dio();

//     try {
//       final response = await dio.post(
//         "http://45.32.19.162/shopping-api/user/login.php",
//         queryParameters: {
//           'username': usernameController.text,
//           'password': passwordController.text
//         },
//         options: Options(
//           followRedirects: false,
//         ),
//       );

//       if (response.statusCode == 200) {
//         print('do login 200');

//         final parsedJson = jsonDecode(response.data);
//         final jwt = parsedJson['jwt'];

//         Token(jwt);
//         print('$jwt');
//         NameUser(usernameController.text);
//         Checkadmin();
//         // Xử lý thành công và tiếp tục với các bước tiếp theo
//       }
//     } catch (e) {
//       if (e is DioException) {
//         if (e.response?.statusCode == 400) {
//           // Xử lý trường hợp yêu cầu trả về mã trạng thái không hợp lệ (400)
//           final responseBody = e.response?.data;
//           print('Lỗi 400: ' + responseBody);
//           final parsedJson = jsonDecode(responseBody);
//           final error = parsedJson['error'];

//           // Sử dụng giá trị error và message tại đây

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('$error')),
//           );
//           // Hiển thị thông báo lỗi hoặc xử lý dữ liệu phản hồi khác tại đây
//         }
//       }
//     }
//   }

//   Future<void> Checkadmin() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String? token2 = pref.getString('login');

//     final url =
//         Uri.parse('http://45.32.19.162/shopping-api/user/check-token.php');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token2',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//       );
//       if (response.statusCode == 200) {
//         print('do check admin 200');
//         print('$token2');
//         print('Response body: ${response.body}');
//         final Map<String, dynamic> parsedJson = jsonDecode(response.body);

//         ApiResponse apiResponse = ApiResponse.fromJson(parsedJson);
//         final infor = apiResponse.data.userData.role;
//         print('$infor');

//         if (infor == 'ADMIN') {
//           print('chuyen man hinh');
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text('Đăng nhập thành công')));
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (context) => ThanhToanSuccess(),
//             ),
//             (route) => false,
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text(
//                   'Đăng nhập thất bại,vui lòng đăng nhập tài khoản ADMIN')));
//         }
//       }
//     } catch (e) {
//       if (e is DioException) {
//         if (e.response?.statusCode == 400) {
//           // Xử lý trường hợp yêu cầu trả về mã trạng thái không hợp lệ (400)
//           final responseBody = e.response?.data;
//           print('Lỗi 400: ' + responseBody);
//           final parsedJson = jsonDecode(responseBody);
//           final error = parsedJson['data'];

//           // Sử dụng giá trị error và message tại đây

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('$error')),
//           );
//           // Hiển thị thông báo lỗi hoặc xử lý dữ liệu phản hồi khác tại đây
//         }
//       }
//     }
//   }

//   Future<void> Token(String token) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setString('login', token);
//   }

//   Future<void> NameUser(String name) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setString('hello', name);
//   }
// }
