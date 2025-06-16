import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_line/dotted_line.dart';
import 'dart:convert';
import 'home.dart';
import 'qr.dart';
import 'acc.dart';
import 'menu.dart';


class HistoryScreen extends StatefulWidget {
  final String email;
  HistoryScreen({required this.email});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  String email = '';
  int id = 0;
  int userId = 0;
  bool no_internet = false;

  Future<void> infoUser(String email) async {

    final Uri url = Uri.parse('https://springboot-kafe.onrender.com/users/info?email=$email');

    try{
      final response = await http.get(url);
      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");
      setState(() {
        no_internet = false;
      });

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody) as Map<String, dynamic>;
        final int getId = data['id'];
        setState(() {
          userId = getId;
        });
        await ordersData(getId);
      } else {}
    }
    catch (e){
      setState(() {
        no_internet = true;
      });
    }
  }


  List<dynamic> orders = [];
  Future<void> ordersData(int userId) async {
    final url = Uri.parse('https://springboot-kafe.onrender.com/api/orders/user/$userId');
    try {
      final response = await http.get(url);

      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> ordersJson = json.decode(decodedBody);

        for (var order in ordersJson) {
          print('Order userId: ${order['userId']}');
          print('Order date: ${order['orderDate']}');
          print('Total price: ${order['totalPrice']}');

          List<dynamic> items = order['items'];
          for (var item in items) {
            print('Item name: ${item['itemName']}');
            print('Quantity: ${item['quantity']}');
          }
        }
        setState(() {
          orders = ordersJson;
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
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
        currentIndex: 3,
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
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScreen(
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
          Center(
            child: Image.asset('assets/images/no_internet.png'),
          );
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
            Expanded(
              child: no_internet
                  ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.4,
                      child: Image.asset('assets/images/no_internet.png'),
                    ),
                  ),
                ],
              )
                  : ListView.builder(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final orderDate = DateTime.parse(order['orderDate']);
                  final formattedDate = "${orderDate.day.toString().padLeft(2,'0')}.${orderDate.month.toString().padLeft(2,'0')}.${orderDate.year} ${orderDate.hour.toString().padLeft(2,'0')}:${orderDate.minute.toString().padLeft(2,'0')}";

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$formattedDate',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF0F0607),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${order['totalPrice']}₴',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF0F0607),
                          ),
                        ),
                        SizedBox(height: 8),
                        DottedLine(
                          direction: Axis.horizontal,
                          lineLength: double.infinity,
                          lineThickness: 2.5,
                          dashLength: 8.0,
                          dashGapLength: 6.0,
                          dashColor: Colors.white,
                        ),
                        SizedBox(height: 4),
                        ...List<Widget>.from(order['items'].map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              '${item['itemName']} x${item['quantity']}',
                              style: TextStyle(fontSize: 20, color: Color(0xFF3E1E20)),
                            ),
                          );
                        })),
                      ],
                    ),
                  );
                },

              ),
            ),

          ],
        ),
      ),
    );
  }
}


