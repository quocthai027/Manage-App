import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'model/productMD.dart';
import 'dart:io';

import 'model/variantMD.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  String price = '';
  String tempSize = '';
  String tempColor = '';
  String tempQuantity = '';
  // Danh sách hình ảnh đã chọn
  List<File> selectedImages = [];

  // Danh sách size, màu sắc và số lượng của sản phẩm
  List<Variant> variants = [];
  List<String> deletedImageNames = [];
  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị ban đầu từ thông tin sản phẩm
    name = widget.product.name;
    description = widget.product.description;
    price = widget.product.price.toString();

    // Khởi tạo danh sách variant từ thông tin sản phẩm
    variants = List<Variant>.from(widget.product.variants.map((variantMap) {
      return Variant.fromJson(variantMap);
    }));
  }

  // Hàm để chọn danh sách hình ảnh từ thư viện
  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        selectedImages.addAll(
            pickedImages.map((pickedImage) => File(pickedImage.path)).toList());
      });
    }
  }

  // Hàm để xóa hình ảnh đã chọn
  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void removeImageCurrent(int index) {
    setState(() {
      final deletedImageName = widget.product.images.removeAt(index);
      deletedImageNames.add(deletedImageName);
      print('Hình ảnh bị xóa: $deletedImageName');
      print(deletedImageNames);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa sản phẩm'),
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên sản phẩm';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(labelText: 'Mô tả'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                TextFormField(
                  initialValue: price,
                  decoration: InputDecoration(labelText: 'Giá'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập giá';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    price = value!;
                  },
                ),

                // Hiển thị danh sách variant
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: variants.length,
                  itemBuilder: (context, index) {
                    final variant = variants[index];
                    String tempSize = variant.size;
                    String tempColor = variant.color;
                    String tempQuantity = variant.quantity.toString();

                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Size: ${variant.size}'),
                          Text('Màu sắc: ${variant.color}'),
                        ],
                      ),
                      subtitle: Text('Số lượng: ${variant.quantity}'),
                      onTap: () {
                        // Biến tạm thời lưu trữ giá trị mới
                        setState(() {
                          variants[index].size = tempSize;
                          variants[index].color = tempColor;
                          variants[index].quantity = int.parse(tempQuantity);
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:
                                  Text('Chỉnh sửa số lượng, size và màu sắc'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    initialValue: variant.size,
                                    decoration:
                                        InputDecoration(labelText: 'Size'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập size';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        tempSize = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    initialValue: variant.color,
                                    decoration:
                                        InputDecoration(labelText: 'Màu sắc'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập màu sắc';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        tempColor = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    initialValue: variant.quantity.toString(),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập số lượng';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      tempQuantity = value;
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Lưu'),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        variant.size = tempSize;
                                        variant.color = tempColor;
                                        variant.quantity =
                                            int.parse(tempQuantity);
                                      });
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Danh sách hình ảnh hiện có',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                if (widget.product.images.isNotEmpty)
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.product.images.length,
                      itemBuilder: (context, index) {
                        final imageUrl = widget.product.images[index];
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 10.0),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () => removeImageCurrent(index),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),
                Text(
                  'Danh sách hình ảnh thêm vào',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                // Hiển thị danh sách hình ảnh đã chọn
                if (selectedImages.isNotEmpty)
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) {
                        final image = selectedImages[index];
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 10.0),
                              child: Image.file(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () => removeImage(index),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),
                // Nút để chọn danh sách hình ảnh từ thư viện
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
                          colors: [Colors.purple, Colors.orange],
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
                        onPressed: pickImages,
                        padding: EdgeInsets.all(16),
                        splashRadius: 24,

                        autofocus: false,
                        enableFeedback: true,
                        alignment: Alignment.center,
                        constraints:
                            BoxConstraints.tightFor(width: 48, height: 48),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Gọi hàm để thực hiện cập nhật thông tin sản phẩm
                        updateProduct();
                      }
                    },
                    child: Text('Lưu thông tin'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProduct() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token2 = pref.getString('login');

    // Xây dựng request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://45.32.19.162/shopping-api/products/update.php'),
    );
    request.headers.addAll({
      'Authorization': 'Bearer $token2',
    });

    // Thêm các trường vào request
    request.fields.addAll({
      'name': name,
      'description': description,
      'price': price,
      'category_id': widget.product.categoryid.toString(),
      'product_id': widget.product.id.toString(),
    });

    //Thêm danh sách hình ảnh đã chọn vào request
    if (selectedImages.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        final image = selectedImages[i];
        final fileName = '${DateTime.now().microsecondsSinceEpoch}_$i.jpg';
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$fileName';

        await image.copy(filePath);
        request.files
            .add(await http.MultipartFile.fromPath('imgs[$i]', filePath));
      }
    }

    // Thêm danh sách tên hình ảnh đã xóa vào request
    if (deletedImageNames.isNotEmpty) {
      final deletedImagesString = deletedImageNames.join(',');
      print('doi thanh string $deletedImagesString');
      request.fields['delete_img'] = deletedImagesString;
    }
    // Thêm danh sách variant vào request
    if (variants.isNotEmpty) {
      for (int i = 0; i < variants.length; i++) {
        final variant = variants[i];
        request.fields['variants[$i][size]'] = variant.size;
        request.fields['variants[$i][color]'] = variant.color;
        request.fields['variants[$i][quantity]'] = variant.quantity.toString();
        request.fields['variants[$i][id]'] = variant.id.toString();
      }
    }
    // Gửi request và lắng nghe phản hồi
    final response = await request.send();

    // Xử lý phản hồi
    if (response.statusCode == 200) {
      // Request successful
      String successResponse = await response.stream.bytesToString();
      print(successResponse);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sửa sản phẩm thành công'),
            content: Text('Trở về danh sách sản phẩm để kiểm tra'),
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
            title: Text('Sửa sản phẩm thất bại'),
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
