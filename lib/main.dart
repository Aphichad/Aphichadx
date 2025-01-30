import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlinedb_gene/showproduct.dart';
import 'addproduct.dart';
import 'showproducttype.dart';

//Method หลักทีRun
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCeQdyeB-JGFjhxToC8qHPw2n2qwrgEf-o",
            authDomain: "onlinedb-11.firebaseapp.com",
            databaseURL:
                "https://onlinedb-11-default-rtdb.asia-southeast1.firebasedatabase.app",
            projectId: "onlinedb-11",
            storageBucket: "onlinedb-11.firebasestorage.app",
            messagingSenderId: "94083416059",
            appId: "1:94083416059:web:a24fcb27314782d329155e",
            measurementId: "G-3RYP0ENC4S"));
  } else {
    await Firebase.initializeApp();
  }
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
      home: Main(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
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
          // Customizing AppBar text style
          title: Text(
            'คลังสินค้า',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          // Adding an action button (e.g., a settings icon)
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Action when the icon is clicked
                print('Settings clicked');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50), // เพิ่มระยะห่างจาก AppBar
                // เพิ่มรูปโลโก้ใน body
                Image.asset(
                  'assets/logo.jpg', // ใส่ path ของโลโก้
                  height: 150,  // กำหนดขนาดสูงของรูป
                  width: 150,   // กำหนดขนาดกว้างของรูป
                ),
                SizedBox(height: 20), // ระยะห่างหลังจากรูป
                // ปุ่มบันทึกสินค้า
                SizedBox(
                  width: 250, // กำหนดความกว้างของปุ่ม
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => addproduct()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.red, width: 2),
                      ),
                      backgroundColor: Colors.red,
                      shadowColor: Colors.red.withOpacity(0.5),
                      elevation: 10,
                    ),
                    child: Text(
                      'บันทึกสินค้า',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // เพิ่มระยะห่างระหว่างปุ่ม
                SizedBox(height: 20),
                // ปุ่มแสดงข้อมูลสินค้า
                SizedBox(
                  width: 250, // กำหนดความกว้างของปุ่มให้เท่ากัน
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => showproduct()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.red, width: 2),
                      ),
                      backgroundColor: Colors.red,
                      shadowColor: Colors.red.withOpacity(0.5),
                      elevation: 10,
                    ),
                    child: Text(
                      'แสดงข้อมูลสินค้า',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // เพิ่มระยะห่างระหว่างปุ่ม
                SizedBox(height: 20),
                // ปุ่มแสดงข้อมูลสินค้า
                SizedBox(
                  width: 250, // กำหนดความกว้างของปุ่มให้เท่ากัน
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowProducttype()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.red, width: 2),
                      ),
                      backgroundColor: Colors.red,
                      shadowColor: Colors.red.withOpacity(0.5),
                      elevation: 10,
                    ),
                    child: Text(
                      'ประเภทสินค้า',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
