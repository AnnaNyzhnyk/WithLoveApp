import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'qr.dart';
import 'history.dart';
import 'acc.dart';
import 'menu.dart';

class ItemsScreen extends StatelessWidget {
  final String email;
  final String categoryName;
  final String subcategoryName;
  final List<Map<String, dynamic>> positions;

  const ItemsScreen({
    Key? key,
    required this.email,
    required this.categoryName,
    required this.subcategoryName,
    required this.positions,
  }) : super(key: key);


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
        //currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(
                email: email,
              )),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen(
                email: email,
              )),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScreen(
                email: email,
              )),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen(
                email: email,
              )),
            );
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccScreen(
                email: email,
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

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: positions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = positions[index];
                  final name = item['name'] ?? '';
                  final price = item['price'] ?? '';
                  final description = item['description'] ?? '';
                  final image = item['photoUrl'] ?? '';

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE4EC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            image,
                            height: 177,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F0607),
                                    ),
                                  ),
                                  Text(
                                    '$price ₴',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F0607),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF0F0607),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


