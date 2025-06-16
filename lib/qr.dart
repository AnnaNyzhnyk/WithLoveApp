import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'home.dart';
import 'history.dart';
import 'acc.dart';
import 'menu.dart';

class QRScreen extends StatefulWidget {
  final String email;
  QRScreen({required this.email});

  @override
  QRScreenState createState() => QRScreenState();
}

class QRScreenState extends State<QRScreen> {

  String email = '';
  int bonusPoints = 0;
  int id = 0;

  void loadUserData() async {
    var box = await Hive.openBox('userBox'); // відкриваємо коробку
    setState(() {
      email = box.get('email', defaultValue: '');
      bonusPoints = box.get('bonusPoints', defaultValue: 0);
      id = box.get('id', defaultValue: 0); // якщо ще не зберігався — буде 0
    });
  }

  Future<void> infoUser(String email) async {
    final Uri url = Uri.parse('https://springboot-kafe.onrender.com/users/info?email=$email');

    try {
      final response = await http.get(url);

      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody) as Map<String, dynamic>;
        final int getId = data['id'];
        final int getBonusPoints = data['bonusPoints'] ?? 0;
        setState(() {
          bonusPoints = getBonusPoints;
          id = getId;
        });
      } else {
      }
    }
    catch (e) {
      Center(
        child: Image.asset('assets/images/no_internet.png'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    infoUser(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFEBA2AC),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 0,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 64,
              child: Center(
                child: Image.asset('assets/images/home.png', width: 54, height: 54),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 64,
              child: Center(
                child: Image.asset('assets/images/menu.png', width: 54, height: 54),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 85,
              child: Center(
                child: Image.asset('assets/images/qr.png', width: 85, height: 85),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 64,
              child: Center(
                child: Image.asset('assets/images/story.png', width: 54, height: 54),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 64,
              child: Center(
                child: Image.asset('assets/images/acc.png', width: 54, height: 54),
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(
                  email: widget.email
              )),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen(
                  email: widget.email
              )),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen(
                  email: widget.email
              )),
            );
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccScreen(
                  email: widget.email
              )),
            );
          }

        },
      ),
      body: SafeArea(
        child: Column(
        children: [
          Container(
          color: Color(0xFFEBA2AC),
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'With Love\ncoffee space',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  width: 92,
                  height: 76,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      Expanded(child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                color: Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 322,
                    height: 322,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    padding: EdgeInsets.all(20),
                    child: QrImageView(
                      data: id.toString(),
                      backgroundColor: Colors.white,
                      size: 282,
                    ),
                  ),
                  const SizedBox(height: 16),

                  DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 2.5,
                    dashLength: 8.0,
                    dashGapLength: 6.0,
                    dashColor: Colors.white,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Ваш QR-код та його номер',
                    style: TextStyle(color: Color(0xFF0F0607), fontSize: 20),
                  ),
                  Text(
                    id.toString(),
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFF0F0607),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Бонуси',
                    style: TextStyle(fontSize: 20, color: Color(0xFF0F0607)),
                  ),
                  Text(
                    bonusPoints.toString(),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFF0F0607)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
      )
        ],
    ),
      ),
    );
  }
}

