import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onlinedb_gene/productdetail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: ShowFilterType(category: 'Books'), // ส่งค่าที่ต้องการ
    );
  }
}

class ShowFilterType extends StatefulWidget {
  final String category; // รับค่าประเภทสินค้า (category)

  const ShowFilterType({super.key, required this.category}); // ค่าที่ได้รับ

  @override
  State<ShowFilterType> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShowFilterType> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final query = dbRef.orderByChild('category').equalTo(widget.category);
      final snapshot = await query.get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];

        for (var child in snapshot.children) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key;
          loadedProducts.add(product);
        }

        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));

        setState(() {
          products = loadedProducts;
        });

        print("จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ");
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Gradient background for the app bar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.red], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'แสดงข้อมูลสินค้า1',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print('Settings clicked');
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200], // เปลี่ยนสีพื้นหลังของ Scaffold
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4.0, // เพิ่มเงาให้กับ Card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // มุมโค้งมน
                  ),
                  color: Colors.white, // สีของ Card
                  child: ListTile(
                    title: Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('รายละเอียดสินค้า: ${product['description']}'),
                        Text('ประเภท: ${product['category']}'),
                        Text('วันที่ผลิต: ${formatDate(product['productionDate'])}'),
                        Text('จำนวน: ${product['quantity']}'),
                      ],
                    ),
                    trailing: Text(
                      'ราคา : ${product['price']} บาท',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // เปลี่ยนสีของราคา
                      ),
                    ),
                    onTap: () {
                      // เมื่อกดที่รายการสินค้า จะไปที่หน้า ProductDetail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => productdetail(
                            product: product, // ส่งข้อมูลของสินค้าไปที่หน้ารายละเอียด
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
