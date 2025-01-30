import 'package:flutter/material.dart';
import 'showfiltertype.dart'; // Import the target page
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowProducttype extends StatefulWidget {
  @override
  State<ShowProducttype> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShowProducttype> {
  // Array of product categories
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> categories = []; // ใช้เก็บ categories

  Future<void> fetchProducts() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        Set<String> seenCategories = Set(); // ใช้เก็บ category ที่เราได้แสดงไปแล้ว
        List<Map<String, dynamic>> loadedCategories = [];

        for (var child in snapshot.children) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          if (!seenCategories.contains(product['category'])) {
            loadedCategories.add(product); // แค่ 1 รายการจากแต่ละ category
            seenCategories.add(product['category']); // เพิ่ม category ที่ได้แสดงไปแล้ว
          }
        }

        setState(() {
          categories = loadedCategories;
        });

        print("จํานวนรายการสินค้าในแต่ละ category: ${categories.length}");
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
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'แสดงสินค้า',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categories.isEmpty
            ? Center(child: CircularProgressIndicator()) // Loading indicator
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      // เมื่อกดที่ card จะไปที่หน้า showfiltertype
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShowFilterType(category: category['category']),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 10, // เพิ่มเงาให้การ์ด
                      shadowColor: Colors.black.withOpacity(0.3), // เงาเบาๆ
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // มุมโค้งมากขึ้น
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red.shade200, Colors.red.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                category['category'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              IconButton(
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 30, // ไอคอนขนาดใหญ่ขึ้น
                                ),
                                onPressed: () {
                                  // เพิ่มฟังก์ชันที่ต้องการเมื่อกดไอคอนนี้
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
