import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'qr.dart';
import 'history.dart';
import 'menu.dart';
//import 'login_screen.dart';
import 'home.dart';

class AccScreen extends StatefulWidget {
  final String email;
  AccScreen({required this.email});

  @override
  AccScreenState createState() => AccScreenState();
}

class AccScreenState extends State<AccScreen> {
  String name = '';
  String birthdate = '';
  String phone = '';
  //int id = 0;

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
        final String getName = data['fullName'];
        final String getBirthdate = data['birthdate'];
        final String getPhone = data['phone'];
        setState(() {
          name = getName;
          birthdate = getBirthdate;
          phone = getPhone;
          //id = getId;
        });
      } else {
        //шось придумаю
      }

    }
    catch (e){
      //щось придумаю
    }

  }

  @override
  void initState() {
    super.initState();
    infoUser(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        currentIndex: 4,
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
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen(
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
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        //padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: EditableField(
                          label: 'Ім’я',
                          initialValue: '$name',
                          onSaved: (value) {
                            print('Нове ім’я: $value');
                          },
                        ),
                      ),
                    ),

                    ///день народження
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: ListTile(
                          title: const Text(
                            'День народження',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F0607),
                            ),
                          ),
                          // Icon(Icons.edit, size: 30, color: Colors.white),
                          trailing: Text(
                            '$birthdate',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F0607),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),

                    ///номер телефону
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        //padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: EditableField(
                          label: 'Номер телефону',
                          initialValue: '$phone',
                          onSaved: (value) {
                            print('Новий номер: $value');
                          },
                        ),
                      ),
                    ),
                    /*/// Зворотний зв'язок
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: ListTile(
                          title: const Text(
                            'Зворотний зв’язок',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F0607),
                            ),
                          ),
                          trailing: Icon(Icons.chevron_right, size: 60, color: Colors.white),
                          onTap: () {},
                        ),
                      ),
                    ),*/

                    /// Вийти
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: ListTile(
                          title: const Text(
                            'Вийти',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F0607),
                            ),
                          ),
                          trailing: Icon(Icons.chevron_right, size: 60, color: Colors.white),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
            ),
            /// Блок з ім’ям

          ],
        ),

      ),
    );
  }
}
class EditableField extends StatefulWidget {
  final String label;
  final String initialValue;
  final void Function(String) onSaved;

  const EditableField({
    required this.label,
    required this.initialValue,
    required this.onSaved,
    super.key,
  });

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  bool isEditing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        //padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFFFCE4EC),
          borderRadius: BorderRadius.circular(35),
        ),
        child: ListTile(
          title: isEditing
              ? TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: widget.label,
              border: InputBorder.none,
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0F0607),
                ),
              ),
              SizedBox(height: 4),
              Text(
                controller.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F0607),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              if (isEditing) {
                widget.onSaved(controller.text);
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ),
      ),
    );
  }
}


