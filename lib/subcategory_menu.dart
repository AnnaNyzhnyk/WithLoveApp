import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'qr.dart';
import 'history.dart';
import 'acc.dart';
import 'menu.dart';
//import 'fake_database.dart';
import 'items_menu.dart';

class SubcategoryScreen extends StatelessWidget {
  final String email;
  final String categoryName;
  final Map<String, List<Map<String, dynamic>>> subcategoryData;


  const SubcategoryScreen({
    Key? key,
    required this.email,
    required this.subcategoryData,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Отримуємо список підкатегорій для переданої категорії
    final List<String> subcategories = subcategoryData.keys.toList();

    Widget buildSubcategoryItem(String title, BuildContext context) {
      return InkWell(
        borderRadius: BorderRadius.circular(35),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemsScreen(
                email: email,
                categoryName: categoryName,
                subcategoryName: title,
                positions: subcategoryData[title]!,
              ),
            ),
          );
        },
        child: Container(
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F0607),
                ),
              ),
            ],
          ),
        ),
      );
    }


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
          // Можеш додати дії для інших кнопок
        },

      ),
      body: SafeArea(
        child:
        Column(
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
              child:
              Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: subcategories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              return buildSubcategoryItem(subcategory, context);
              },
          ),
        ),
      ),
            ]
        ),
      ),
    );
  }
}






