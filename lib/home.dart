import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'qr.dart';
import 'history.dart';
import 'acc.dart';
import 'menu.dart';


class HomeScreen extends StatefulWidget {
  final String email;
  HomeScreen({required this.email});

  @override
  HomeScreenState createState() => HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {
  //String email = '';
  String name = '';
  String birthdate = '';
  String phone = '';
  int bonusPoints = 0;
  int id = 0;

  Future<void> infoUser(String email) async {

    final Uri url = Uri.parse('https://springboot-kafe.onrender.com/users/info?email=$email');

    try{
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
        final box = await Hive.openBox('userBox');
        await box.put('id', id);
        await box.put('bonusPoints', bonusPoints);
      } else {
      }

    }
    catch (e){
    }

  }

  void loadUserData() async {
    var box = await Hive.openBox('userBox');
    setState(() {
      bonusPoints = box.get('bonusPoints', defaultValue: 0);
      id = box.get('id', defaultValue: 0);
    });
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen(
                email: widget.email
              )),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScreen(
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
                    style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
            Expanded(
              child: ListView(
                  children: [
                    Column(
                        children:
                        [Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFFCE4EC),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Бонуси', style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F0607))
                                    ),
                                    const SizedBox(height: 8),
                                    Text('$bonusPoints', style: TextStyle(fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F0607))),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.wifi, size: 20, color: Color(0xFF0F0607)),
                                    SizedBox(height: 4),
                                    Text(
                                      'MadeWithLove',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Color(0xFF0F0607),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => QRScreen(
                                    email: widget.email
                                )),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              height: 234,
                              decoration: BoxDecoration(
                                color: Color(0xFFFCE4EC),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Ваш\nособистий\nQR-код',
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F0607)),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: QrImageView(
                                      data: '$id',
                                      size: 170,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16,),
                        ]
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}