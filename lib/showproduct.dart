import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Method หลักทีRun
void main() {
  runApp(const MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: showproduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showproduct extends StatefulWidget {
  const showproduct({super.key});

  @override
  State<showproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproduct> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
// สร้าง referenceชื่อ dbRef ไปยังตารางชื่อ products
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      //กรอง
      //เติมบรรทัดที่ใช้ query ข้อมูล กรองสินค้าที่ราคา >= 500
      final query = dbRef.orderByChild('price').startAt(10);
// ดึงข้อมูลจาก Realtime Database
      final snapshot = await query.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
// วนลูปเพื่อแปลงข้อมูลเป็ น Map
        for (var child in snapshot.children) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        }

        //เรียง
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));

// อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
// แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
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

//ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
// ปุ่มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: const Color.fromARGB(255, 255, 32, 32),
                  ),
                );
              },
              child: Text('ยืนยัน',
                  style:
                      TextStyle(color: const Color.fromARGB(216, 255, 0, 0))),
            ),
          ],
        );
      },
    );
  }

//ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    // สร้าง TextEditingController สำหรับฟิลด์ต่าง ๆ
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());
    TextEditingController dateController =
        TextEditingController(text: product['productionDate']);
    TextEditingController categoryController =
        TextEditingController(text: product['category']);
    TextEditingController discountController = TextEditingController(
        text:
            product['discount'] ?? ''); // หากไม่มีค่า ให้ใช้ค่าเริ่มต้นเป็น ''

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                      labelText: 'วันที่ผลิต (yyyy-MM-ddTHH:mm:ss.sss)'),
                  onTap: () async {
                    // ใช้ DatePicker เพื่อเลือกวันที่
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      dateController.text = pickedDate
                          .toIso8601String(); // แปลงวันที่เป็น ISO String
                    }
                  },
                  readOnly: true,
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'ประเภท'),
                ),
                TextField(
                  controller: discountController,
                  decoration: InputDecoration(
                      labelText: 'ส่วนลด (เช่น 10%, ไม่มีส่วนลด)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // เตรียมข้อมูลที่แก้ไขแล้ว
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'quantity': int.parse(quantityController.text),
                  'productionDate': dateController.text,
                  'category': categoryController.text,
                  'discount': discountController.text,
                };

                // อัปเดตข้อมูลใน Firebase
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // โหลดข้อมูลใหม่
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });

                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

//ส่วนการออกแบบหน้าจอ
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
          'แสดงข้อมูลสินค้า',
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
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // จํานวนคอลัมน์
                crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
                childAspectRatio: 1.5,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    //รอใส่codeว่ากดแล้วเกิดอะไรขึ ้น
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(product['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('รายละเอียดสินค้า: ${product['description']}'),
                          Text(
                              'วันที่ผลิต: ${formatDate(product['productionDate'])}'),
                          Text('ราคา : ${product['price']} บาท'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // จัดตำแหน่งปุ่มให้อยู่ตรงกลาง
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 30,
                                  child: Container(
                                    child: IconButton(
                                      onPressed: () {
                                        // เปิด Dialog แก้ไขสินค้า
                                        showEditProductDialog(product);
                                      },
                                      icon: Icon(Icons.edit),
                                      color: const Color.fromARGB(
                                          255, 0, 66, 248), // สีของไอคอน
                                      iconSize: 25,
                                      tooltip: 'แก้ไข',
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 30,
                                  child: Container(
                                    child: IconButton(
                                      onPressed: () {
                                        // แสดง Dialog ยืนยันการลบสินค้า
                                        showDeleteConfirmationDialog(
                                            product['key'], context);
                                      },
                                      icon: Icon(Icons.delete),
                                      color: Colors.red, // สีของไอคอนลบ
                                      iconSize: 25,
                                      tooltip: 'ลบ',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      onTap: () {
//เมื่อกดที่แต่ละรายการจะเกิดอะไรขึ้น
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
