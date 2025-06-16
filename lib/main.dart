import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'reg_screen.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // ініціалізація Hive
  await Hive.openBox('userBox'); // відкриває box для зберігання//головна функція
  runApp(WithLoveApp()); //запускаємо основний клас(застосунок)
}

class WithLoveApp extends StatefulWidget {

  @override
  WithLoveAppState createState() => WithLoveAppState();
}

class WithLoveAppState extends State<WithLoveApp> { // описуємо основний клас
  @override
  Widget build(BuildContext context) { //метод build, що створює візуал
    return MaterialApp( //повертаємо основні дані про застосунок
      theme: ThemeData( // тема(колір, шрифти)
        canvasColor: Color(0xFFEBA2AC) //основний фон для більшості об'єктів
      ),
      title: 'With Love Coffee Space', //назва
      home: LoginScreen(), //екран, з якого запускається застосунок
      debugShowCheckedModeBanner: false, //відключає напис дебаг
    );
  }
}

class LoginScreen extends StatefulWidget{
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  String email = '';
  String name = '';
  String birthdate = '';
  String phone = '';
  int bonusPoints = 0;
  int id = 0;

  void loadUserData() async {
    var box = await Hive.openBox('userBox'); // відкриваємо коробку
    setState(() {
      email = box.get('email', defaultValue: '');
      name = box.get('fullName', defaultValue: '');
      phone = box.get('phone', defaultValue: '');
      birthdate = box.get('birthdate', defaultValue: '');
      bonusPoints = box.get('bonusPoints', defaultValue: 0);
      id = box.get('id', defaultValue: 0); // якщо ще не зберігався — буде 0
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //bool isLoading = false;

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            contentPadding: EdgeInsets.all(16),
            title: Center(
              child: Text('Помилка',
                style: TextStyle(
                  color: Color(0xFF0F0607),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Wrap(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text('Заповніть всі поля.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0F0607),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xffFCE4EC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: Text('ОК',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )

            ],
          );
        },
      );
      return;
    }
    /*setState(() {
      isLoading = true;
    });*/

    final url = Uri.parse("https://springboot-kafe.onrender.com/users/login");
    final Map<String, dynamic> userData = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try{
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),

      );

      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final email = emailController.text;
        emailController.clear();
        passwordController.clear();

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(
                email: email
            ))
        );
      }
      else {
        if (response.statusCode == 401) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                contentPadding: EdgeInsets.all(16),
                title: Center(
                  child: Text('Помилка',
                    style: TextStyle(
                      color: Color(0xFF0F0607),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: Wrap(
                  children: [
                    Center(
                      child: Text('Невірна пошта або пароль.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0F0607),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xffFCE4EC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      child: Text('ОК',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )

                ],
              );
            },
          );
        }
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                contentPadding: EdgeInsets.all(16),
                title: Center(
                  child: Text('Помилка',
                    style: TextStyle(
                      color: Color(0xFF0F0607),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: Wrap(
                  children: [
                    Center(
                      child: Text('Сталася помилка. \n Спробуйте ще раз.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0F0607),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xffFCE4EC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      child: Text('ОК',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )

                ],
              );
            },
          );
        }
      }
    }
    catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            contentPadding: EdgeInsets.all(16),
            title: Center(
              child: Text('Помилка',
                style: TextStyle(
                  color: Color(0xFF0F0607),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Wrap(
              children: [
                Center(
                  child: Text('Перевірте підключення до інтернету',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F0607),
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xffFCE4EC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: Text('ОК',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    };
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffEBA2AC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24), // щоб не прилипало до краю
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch, // дозволяє займати всю ширину
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: AspectRatio(
                        aspectRatio: 336 / 277, // пропорції твоєї картинки
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ваша пошта',
                      style: TextStyle(
                          color: Color(0xFF0F0607), fontSize: 20
                      ),
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: '...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Пароль',
                      style: TextStyle(
                          color: Color(0xFF0F0607), fontSize: 20
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(35),
                      onTap: () {
                        loginUser();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: const Text(
                          'Увійти',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0F0607),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegScreen()),
                        );
                      },
                      child: const Text(
                        'Зареєструватися',
                        style: TextStyle(
                          color: Color(0xFF0F0607), fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


