import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'qr.dart';
import 'acc.dart';
import 'menu.dart';
import 'order_detail.dart';
//import 'fake_database.dart';

class HistoryScreen extends StatefulWidget {
  final String email;
  HistoryScreen({required this.email});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  int userId = 0;

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
        setState(() {
          userId = getId;
        });
        await menuData();
        await ordersData(getId);
      } else {}
    }
    catch (e){}
  }


  Map<String, Map<String, List<Map<String, dynamic>>>> _menuData = {};
  Future<void> menuData() async {
    final url = Uri.parse('https://springboot-kafe.onrender.com/menuitems/grouped'); // 👈 замінити

    try {
      final response = await http.get(url);

      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody) as Map<String, dynamic>;
        _menuData = data.map((categoryKey, subcategoriesValue) {
          final subcategories = (subcategoriesValue as Map<String, dynamic>).map((subcategoryKey, itemsValue) {
            final itemsList = (itemsValue as List<dynamic>).map((item) => item as Map<String, dynamic>).toList();
            return MapEntry(subcategoryKey, itemsList);
          });
          return MapEntry(categoryKey, subcategories);
        });
        setState(() {});
      } else {
      }
    }
    catch (e){
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

  double findPrice(int itemId) {
    for (var category in _menuData.values) {
      for (var subcategory in category.values) {
        for (var menuItem in subcategory) {
          if (menuItem['id'] == itemId) {
            return menuItem['price']?.toDouble() ?? 0.0;
          }
        }
      }
    }
    return 0.0;
  }

  List<Map<String, dynamic>> orderItemsWithPrice(List<dynamic> orderItems) {
    List<Map<String, dynamic>> result = [];
    for (var item in orderItems) {
      int itemId = item['itemId'];
      int quantity = item['quantity'];

      double price = findPrice(itemId);
      result.add({
        'itemId': itemId,
        'quantity': quantity,
        'price': price,
      });
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await infoUser(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    //final List<Map<String, dynamic>> allOrders = orders;
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
              child: ListView.builder(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onTap: () {
                      // Перехід на екран з деталями замовлення
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
                            email: widget.email,
                            order: {
                              ...order,
                              'items': orderItemsWithPrice(order['items']),
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Дата: ${order['orderDate']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0F0607),
                            ),
                          ),
                        ],
                      ),
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


