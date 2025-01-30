import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Class stateless สั่งแสดงผลหน้าจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: productdetail(
        // ส่งข้อมูลสินค้าไปที่หน้า ProductDetail
        product: {
          'name': 'Sample Product',
          'category': 'Books',
          'description': 'This is a sample product description.',
          'productionDate': '2024-12-01',
          'quantity': 10,
          'price': 200
        },
      ),
    );
  }
}

// Class stateful เรียกใช้การทำงานแบบโต้ตอบ
class productdetail extends StatefulWidget {
  final Map<String, dynamic> product; // รับข้อมูลสินค้า

  // Constructor เพื่อรับข้อมูลสินค้า
  const productdetail({super.key, required this.product});

  @override
  State<productdetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<productdetail> {
  // ฟังก์ชันสำหรับจัดรูปแบบวันที่
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    // เข้าถึงข้อมูลสินค้าโดยการใช้ widget.product
    final product = widget.product;

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
          'ประเภทสินค้า',
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
      backgroundColor: Colors.grey[50], // สีพื้นหลังที่เบาและสะอาด
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${product['name']}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple, // สีของชื่อสินค้า
                  ),
            ),
            SizedBox(height: 16),
            Text(
              'รายละเอียดสินค้า',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87, // สีหัวข้อรายละเอียด
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              '${product['description']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, // สีข้อความรายละเอียด
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.category, color: Colors.red),
                SizedBox(width: 8),
                Text('ประเภท: ${product['category']}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'วันที่ผลิต: ${formatDate(product['productionDate'])}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.confirmation_number, color: Colors.green),
                SizedBox(width: 8),
                Text('จำนวน: ${product['quantity']}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'ราคา: ฿${product['price']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
