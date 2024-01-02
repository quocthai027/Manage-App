import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'addproduct.dart';
import 'editproduct.dart';
import 'model/productMD.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productsMain = [];
  int currentPage = 1;
  bool isLastPage = false;
  bool isLoading = false;
  bool isLoadingMore = false;
  ScrollController _scrollController = ScrollController();
  TextEditingController searchproductcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchProducts(currentPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts(int page) async {
    setState(() {
      isLoading = true; // Đánh dấu đang tải dữ liệu
    });

    final response = await http.get(Uri.parse(
        'http://45.32.19.162/shopping-api/products/list.php?page=$page&limit=6'));

    if (response.statusCode == 200) {
      final jsonResult = json.decode(response.body);
      final productList = jsonResult['products'] as List<dynamic>;
      final bool apiIsLastPage = jsonResult['is_last_page'];
      final bool hasMoreData = (productList.length > 0);

      setState(() {
        isLastPage = apiIsLastPage;
        if (page == 1) {
          productsMain = productList
              .map((item) => Product(
                  id: item['id'],
                  name: item['name'],
                  description: item['description'],
                  price: item['price'],
                  images: List<String>.from(item['images_list']),
                  variants: List<Map<String, dynamic>>.from(item['variants']),
                  views: item['views'],
                  categoryid: item['category_id']))
              .toList();
        } else {
          productsMain.addAll(productList.map((item) => Product(
              id: item['id'],
              name: item['name'],
              description: item['description'],
              price: item['price'],
              images: List<String>.from(item['images_list']),
              variants: List<Map<String, dynamic>>.from(item['variants']),
              views: item['views'],
              categoryid: item['category_id'])));
        }
        isLoading = false; // Đánh dấu kết thúc tải dữ liệu
        isLoadingMore = false;
        if (!hasMoreData) {
          isLastPage = true;
        }
      });
    } else {
      throw Exception('Failed to fetch products');
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Quản lý kho sản phẩm',
            style: TextStyle(
              fontSize: 24, // Kích thước chữ
              fontWeight: FontWeight.bold, // Độ đậm của chữ
              color: Colors.blue, // Màu chữ
              letterSpacing: 1.5, // Khoảng cách giữa các ký tự
              wordSpacing: 2.0, // Khoảng cách giữa các từ
              fontStyle: FontStyle.italic, // Kiểu chữ nghiêng
              decoration: TextDecoration.underline, // Gạch chân chữ
              decorationColor: Colors.red, // Màu gạch chân chữ
              decorationThickness: 2.0, // Độ dày của gạch chân chữ
              shadows: [
                Shadow(
                  color: Colors.black, // Màu đổ bóng
                  offset: Offset(2, 2), // Vị trí đổ bóng (tọa độ X, Y)
                  blurRadius: 3, // Độ mờ của bóng
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Container(
                width: 180,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProductScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.all(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Thêm sản phẩm',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchproductcontroller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tìm kiếm sản phẩm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.all(8.0),
              ),
              onChanged: (value) {
                SearchProduct();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: productsMain.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < productsMain.length) {
                  final product = productsMain[index];
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
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.network(
                                product.images[0],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: product.description,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Giá:\$${product.price}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.grey,
                                        decorationStyle:
                                            TextDecorationStyle.dotted,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _navigateToEditScreen(product);
                                    // Xử lý sự kiện khi nhấn nút sửa sản phẩm
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    removeProduct(product);
                                    // Xử lý sự kiện khi nhấn nút xóa sản phẩm
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (isLoadingMore) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return SizedBox
                      .shrink(); // Khi không tải thêm sản phẩm, trả về một widget rỗng để không có khoảng trống thừa
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void loadMoreProducts() {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      currentPage++;
      print('$currentPage');
      fetchProducts(currentPage);
    }
  }

  Future<void> removeProduct(Product product) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                removeFromProduct(product); // Xóa sản phẩm khỏi giỏ hàng
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> removeFromProduct(Product product) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token2 = pref.getString('login');

    final url = Uri.parse(
        'http://45.32.19.162/shopping-api/products/delete.php?product_id=${product.id}');
    final body = {
      'product_id': product.id.toString(),
      'is_deleted': 1.toString()
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token2',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Product deleted successfully');

      setState(() {
        fetchProducts(currentPage);
      });
      // Tải lại danh sách sản phẩm sau khi xóa thành công
    } else {
      print('Failed to delete product. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> SearchProduct() async {
    final textserch = searchproductcontroller.text;
    final response = await http.get(Uri.parse(
        'http://45.32.19.162/shopping-api/products/list.php?search=$textserch&limit=6'));
    if (response.statusCode == 200) {
      final jsonResult = json.decode(response.body);
      final productList = jsonResult['products'] as List<dynamic>;
      setState(() {
        productsMain = productList
            .map((item) => Product(
                id: item['id'],
                name: item['name'],
                description: item['description'],
                price: item['price'],
                images: List<String>.from(item['images_list']),
                variants: List<Map<String, dynamic>>.from(item['variants']),
                views: item['views'],
                categoryid: item['category_id']))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch products search');
      // Handle errors
    }
  }

  void _navigateToEditScreen(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    );
  }
}
