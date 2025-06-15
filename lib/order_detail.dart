import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'home.dart';
import 'qr.dart';
import 'history.dart';
import 'acc.dart';
import 'menu.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String email;
  final Map<String, dynamic> order;

  OrderDetailsScreen({required this.order, required this.email});

  @override
  Widget build(BuildContext context) {

    final DateTime orderDate = DateFormat('dd.MM.yyyy').parse(order['orderDate']);
    final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(order['items'] ?? []);

    final double total = (order['totalPrice'] as num).toDouble();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFEBA2AC),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 0, // щоб Flutter не задавав зайві відступи
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
                  email: email
              )),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen(
                  email: email
              )),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScreen(
                  email: email
              )),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen(
                  email: email
              )),
            );
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccScreen(
                  email: email
              )),
            );
          }
          // Можеш додати дії для інших кнопок
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 50),
                    ),
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 16),
            Expanded(child: ListView(
              children: [
                Column(
                    children: [
                      //const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFFCE4EC),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd.MM.yyyy').format(orderDate),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              for (var item in items)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${item['itemName']} x${item['quantity']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                      Text('${item['price']} x ${item['quantity']} = ${item['price'] * item['quantity']} ₴', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 2.5,
                                dashLength: 8.0,
                                dashGapLength: 6.0,
                                dashColor: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '$total ₴',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              ],


            ),
            ),

          ],
        ),
      ),
    );
  }
}
