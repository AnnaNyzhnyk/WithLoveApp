import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'qr.dart';
import 'history.dart';
import 'acc.dart';
//import 'fake_database.dart'; // <-- тут у нас categoryData
import 'subcategory_menu.dart'; // Для переходу на SubcategoryScreen

class MenuScreen extends StatefulWidget {
  final String email;
  MenuScreen({required this.email});

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {

  bool no_internet = false;
  Map<String, Map<String, List<Map<String, dynamic>>>> _menuData = {};
  Future<void> menuData() async {
    final url = Uri.parse('https://springboot-kafe.onrender.com/api/menuitems/grouped'); // 👈 замінити

    try {
      setState(() {
        no_internet = false;  // успішно завантажили — помилки немає
      });
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
        //тут буде картинка або напис, що нічо нема
      }

    }
    catch (e){
      setState(() {
        no_internet = true;
      });
      /*Center(
        child: Image.asset('assets/images/no_internet.png'),
      );*/
    }

  }

  // Функція для побудови елемента категорії
  Widget buildCategoryItem(String title, BuildContext context) {
    return SizedBox(
      height: 80,
      child:
        InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: () {
            final subcategories = _menuData[title]!.keys.toList();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubcategoryScreen(
                  email: widget.email,
                  categoryName: title,
                  subcategoryData: _menuData[title]!,
                ),
              ),
            );
          },
          child: Container(
            // margin прибираємо, щоб не накладалися відступи
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F0607),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }


  @override
  void initState() {
    super.initState();
    menuData();
  }
  @override
  Widget build(BuildContext context) {
    final List<String> categories = _menuData.keys
        .toList(); // Отримуємо список категорій

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFEBA2AC),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 0,
        // щоб Flutter не задавав зайві відступи
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 64,
              child: Center(
                child: Image.asset(
                    'assets/images/home.png', width: 54, height: 54),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 64,
              child: Center(
                child: Image.asset(
                    'assets/images/menu.png', width: 54, height: 54),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 85,
              child: Center(
                child: Image.asset(
                    'assets/images/qr.png', width: 85, height: 85),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 64,
              child: Center(
                child: Image.asset(
                    'assets/images/story.png', width: 54, height: 54),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 64,
              child: Center(
                child: Image.asset(
                    'assets/images/acc.png', width: 54, height: 54),
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(
                email: widget.email,
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
          // Можеш додати дії для інших кнопок
        },

      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFEBA2AC),
              padding: const EdgeInsets.all(16),
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

            //const SizedBox(height: 16),

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
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                // відступ з усіх боків
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return buildCategoryItem(category, context);
                },
                separatorBuilder: (_, __) =>
                const SizedBox(
                    height: 16), // вертикальний відступ між категоріями
              ),
            ),
          ],
        ),
      ),
    );
  }
  }

