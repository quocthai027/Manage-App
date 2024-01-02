import 'package:flutter/material.dart';
import 'package:flutter_application_21/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'model/manageUserMD.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> userList = [];
  bool isLoading = false;
  bool isLastPage = false;
  int currentPage = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUserList();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      loadMoreUsers();
    }
  }

  Future<void> fetchUserList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token2 = pref.getString('login');
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://45.32.19.162/shopping-api/user/list.php?page=$currentPage'),
        headers: {
          'Authorization': 'Bearer $token2',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        final userListData = jsonResult['users'] as List<dynamic>;
        final bool apiIsLastPage = jsonResult['is_last_page'];
        setState(() {
          // userList.clear();
          userList.addAll(
              userListData.map((userJson) => User.fromJson(userJson)).toList());

          isLastPage = apiIsLastPage;
          isLoading = false;
        });
        setState(() {});
      } else {
        throw Exception('Failed to fetch user list');
      }
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadMoreUsers() {
    if (!isLoading && !isLastPage) {
      currentPage++;
      fetchUserList();
    }
  }

  Future<void> updateUser(int userId, int status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('login');

    final url =
        Uri.parse('http://45.32.19.162/shopping-api/user/update-status.php');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'user_id': userId.toString(),
      'status': status.toString(),
    };

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Thành công cập nhật');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật trạng thái User thành công')),
      );
      // Refresh user list
      await fetchUserList();
      // Cập nhật lại giao diện
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  void showConfirmationDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(user.status == 0 ? 'Mở khóa user?' : 'Khóa user?'),
        content: Text(user.status == 0
            ? 'Nhấn OK để mở khóa user'
            : 'Nhấn OK để khóa user'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'HỦY'),
            child: const Text('HỦY'),
          ),
          TextButton(
            onPressed: () {
              int newStatus = user.status == 0 ? 1 : 0;
              updateUser(user.id, newStatus);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Ẩn nút quay lại
        title: Text(
          'Danh sách User',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0, // Remove shadow
        toolbarHeight: 50, // Adjust the height as needed
        centerTitle: true,
        titleSpacing: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),
        // Customize other properties like leading, actions, etc. if needed
      ),
      body: Container(
        height: 450,
        child: ListView.builder(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: userList.length + 1,
          itemBuilder: (context, index) {
            if (index < userList.length) {
              final user = userList[index];

              String userStatusText =
                  user.status == 0 ? 'Đã khóa' : 'Hoạt động';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    width: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Tên: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      user.name,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Email: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      user.username,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Vai trò: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      user.role,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Trạng thái: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      userStatusText,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => showConfirmationDialog(user),
                          child: Icon(
                            user.status == 0 ? Icons.lock_open : Icons.lock,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (isLoading) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
