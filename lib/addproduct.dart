import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onlinedb_gene/main.dart';
import 'showproduct.dart';
//Method หลักทีRun
void main() {
  runApp(MyApp());
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
      home: addproduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class addproduct extends StatefulWidget {
  @override
  State<addproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<addproduct> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

//ประกาศตัวแปรdropdown
  final Category = ['เครื่องใช้ไฟฟ้า', 'เสื้อผ้า', 'อาหาร', 'หนังสือ'];
  String? selectedCategory;
  final discount = ['ไม่ให้ส่วนลด', 'ส่วนลด10%'];
  String? selectedDiscount;
  //
  //ประกาศตัวแปรเก็บค้าการเลือกวันที่
  final TextEditingController dateController = TextEditingController();
  DateTime? productionDate;
//สร้างฟังก์ชันให้เลือกวันที่
  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

//วางFuture
  Future<void> saveProductToDatabase() async {
    try {
// สร้าง reference ไปยัง Firebase Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
//ข้อมูลสินค้าที่จะจัดเก็บในรูปแบบ Map
      //ชื่อตัวแปรที่รับค่าที่ผู้ใช้ป้อนจากฟอร์มต้องตรงกับชื่อตัวแปรที่ตั้งตอนสร้างฟอร์มเพื่อรับค่า
      Map<String, dynamic> productData = {
        'name': nameController.text,
        'description': desController.text,
        'category': selectedCategory,
        'productionDate': productionDate?.toIso8601String(),
        'price': double.parse(priceController.text),
        'quantity': int.parse(quantityController.text),
        'discount' : selectedDiscount,
      };
//ใช้คําสั่ง push() เพื่อสร้าง key อัตโนมัติสําหรับสินค้าใหม่
      await dbRef.push().set(productData);
//แจ้งเตือนเมื่อบันทึกสําเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสําเร็จ')),
      );

      // นําทางไปยังหน้า ShowProduct
Navigator.push(
context,
MaterialPageRoute(builder: (context) => showproduct()),
);
// รีเซ็ตฟอร์ม
      _formKey.currentState?.reset();
      nameController.clear();
      desController.clear();
      priceController.clear();
      quantityController.clear();
      dateController.clear();
      setState(() {
        selectedCategory = null;
        selectedDiscount = null;
        productionDate = null;
      });
    } catch (e) {
//แจ้งเตือนเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

// ฟังก์ชันเคลียร์ฟอร์ม
  void clearForm() {
    nameController.clear();
    desController.clear();
    priceController.clear();
    quantityController.clear();
    dateController.clear();
    setState(() {
      selectedCategory = null;
      selectedDiscount = null;
      productionDate = null;
    });
  }

//ส่วนการออกแบบหน้าจอ
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
          'คลังสินค้า',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
  icon: Icon(Icons.arrow_back, color: Colors.white), // ปุ่มย้อนกลับ
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Main()), // เปลี่ยนหน้าไปที่ Main
    );
  },
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  maxLines: 1,
                  keyboardType: TextInputType.text, // Keyboard for text input
                  decoration: InputDecoration(
                    labelText: 'ชื่อสินค้า*',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                    ),
                    // You can also define the border color here
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: desController,
                  maxLines: 3,
                  keyboardType: TextInputType.text, // Keyboard for text input
                  decoration: InputDecoration(
                    labelText: 'รายละเอียดสินค้า*',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                    ),
                    // You can also define the border color here
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียดสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'ประเภทสินค้า',
                    border: OutlineInputBorder(
                      // กำหนดกรอบ
                      borderRadius: BorderRadius.circular(12.0), // มุมโค้ง
                    ),
                  ),
                  items: Category
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกประเภทสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: dateController,
                  maxLines: 3,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'วันที่ผลิตสินค้า',
                    border: OutlineInputBorder(
                      // เพิ่มกรอบ
                      borderRadius: BorderRadius.circular(12.0), // มุมโค้ง
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => pickProductionDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกวันที่ผลิต';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: priceController,
                    maxLines: 1,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true), // Keyboard for numeric input
                    decoration: InputDecoration(
                      labelText: 'ราคาสินค้า*',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                      ),
                      // You can also define the border color here
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกจำนวนสินค้า';
                      }
                      if (int.tryParse(value) == null) {
                        return 'กรุณากรอกจำนวนสินค้าเป็นตัวเลข';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: quantityController,
                  maxLines: 1,
                  keyboardType:
                      TextInputType.number, // Keyboard for numeric input
                  decoration: InputDecoration(
                    labelText: 'จำนวนสินค้า*',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                    ),
                    // You can also define the border color here
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนสินค้า';
                    }
                    if (int.tryParse(value) == null) {
                      return 'กรุณากรอกจำนวนสินค้าเป็นตัวเลข';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  value: selectedDiscount,
                  decoration: InputDecoration(
                    labelText: 'ส่วนลดสินค้า',
                    border: OutlineInputBorder(
                      // กำหนดกรอบ
                      borderRadius: BorderRadius.circular(12.0), // มุมโค้ง
                    ),
                  ),
                  items: discount
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDiscount = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกส่วนลดสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ดำเนินการเมื่อฟอรมผานการตรวจสอบ
                      saveProductToDatabase();
                    }
                  },
                  child: Text('บันทึกสินค้า'),
                ),
              SizedBox(height: 10),
                ElevatedButton(
                  onPressed: clearForm, // ปุ่มเคลียร์
                  child: Text('เคลียร์ข้อมูล'),
                  style: ElevatedButton.styleFrom(
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

