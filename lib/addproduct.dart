import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_21/main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'homepage.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<File> imageFiles = [];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token2 = pref.getString('login');
      // Build the request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://45.32.19.162/shopping-api/products/add.php'),
      );
      request.headers['Authorization'] = 'Bearer $token2';

      // Add form fields
      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['price'] = _priceController.text;
      request.fields['category_id'] = _categoryController.text;
      request.fields['variants[0][color]'] = _colorController.text;
      request.fields['variants[0][size]'] = _sizeController.text;
      request.fields['variants[0][quantity]'] = _quantityController.text;

      // Add image files
      for (var i = 0; i < imageFiles.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'imgs[${i.toString()}]',
          imageFiles[i].path,
        ));
      }

      // Send the request
      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        // Request successful
        String successResponse = await response.stream.bytesToString();
        print(successResponse);

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thêm sản phẩm thành công'),
              content: Text('Trờ về danh sách sản phẩm để kiểm tra'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );

        // Add any further processing or navigation here
      } else {
        // Request failed
        String errorResponse = await response.stream.bytesToString();
        print(errorResponse);
        Map<String, dynamic> jsonResponse = json.decode(errorResponse);
        String errorMessage = jsonResponse['fail'];
        // Handle the error appropriately, e.g., show an error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thêm sản phẩm thất bại'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        imageFiles.add(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text('Thêm vào kho'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập tên';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Mô tả'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập mô tả';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(labelText: 'Giá tiền'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập giá';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(labelText: 'ID Danh Mục'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập ID danh mục';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _colorController,
                      decoration: InputDecoration(labelText: 'Color'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập màu';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _sizeController,
                      decoration: InputDecoration(labelText: 'Size'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập Size';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(labelText: 'Số lượng'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập số lượng';
                        }
                        return null;
                      },
                    ),
                    // Form fields...
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(imageFiles.length, (index) {
                return Stack(
                  children: [
                    Image.file(
                      imageFiles[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.remove_circle),
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            imageFiles.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Thêm hình ảnh:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.blue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _pickImage,
                    padding: EdgeInsets.all(16),
                    splashRadius: 24,

                    autofocus: false,
                    enableFeedback: true,
                    alignment: Alignment.center,
                    constraints: BoxConstraints.tightFor(width: 48, height: 48),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    focusColor: Colors.blue,
                    hoverColor: Colors.blue,
                    highlightColor: Colors.blue,
                    splashColor: Colors.blue,
                    disabledColor: Colors.grey,
                    color: Colors.green,
                    // Đặt decoration tại đây nếu bạn muốn thêm background, border, hoặc box shadow cho IconButton.
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
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
                onPressed: _submitForm,
                child: Text('Thêm sản phẩm'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
