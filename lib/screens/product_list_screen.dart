import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';
import 'add_new_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _inProgress = false;

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: RichText(
            text: TextSpan(
                text: "Product",
                style: GoogleFonts.russoOne().copyWith(
                    color: Colors.pink,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "List",
                    style:
                        GoogleFonts.russoOne().copyWith(color: Colors.yellow),
                  ),
                  TextSpan(
                    text: "Screen",
                    style: GoogleFonts.russoOne()
                        .copyWith(color: Colors.greenAccent),
                  ),
                ]),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 24,
            ),
            onPressed: () {
              getProductList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddNewProductScreen()));
        },
        child: Icon(
          Icons.add,
          size: 24.sp,
        ),
      ),
      body:_inProgress?const Center(child: CircularProgressIndicator()) :SafeArea(
          child: ListView.separated(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return ProductItem(
            product: productList[index],
            onTapDelete: () {deleteProduct(productList[index].id);},
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox();
        },
      )),
    );
  }

  Future<void> getProductList() async {
    _inProgress = true;
    setState(() {
    });
    Uri url = Uri.parse("http://164.68.107.70:6060/api/v1/ReadProduct");
    Response response = await get(url);
    print(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      productList.clear();
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      for (var item in jsonResponse['data']) {
        Product product = Product(
          id: item['_id'],
          productName: item['ProductName'] ?? '',
          productCode: item['ProductCode'] ?? '',
          productImage: item['Img'] ?? '',
          unitPrice: item['UnitPrice'] ?? '',
          quantity: item['Qty'] ?? '',
          totalPrice: item['TotalPrice'] ?? '',
          createdAt: item['CreatedDate'] ?? '',
        );
        productList.add(product);
      }
    }
    _inProgress = false;
    setState(() {});
  }
  Future<void> deleteProduct(id) async {
    Uri uri = Uri.parse('http://164.68.107.70:6060/api/v1/DeleteProduct/$id');

    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      getProductList();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product Delete Successfully')));
    }
  }
}
