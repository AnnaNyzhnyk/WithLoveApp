import 'package:flutter/material.dart';
//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'reg2_screen.dart';

class RegScreen extends StatefulWidget{
  @override
  RegScreenState createState() => RegScreenState();
}

class RegScreenState extends State<RegScreen>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 Future<void>  registerUser() async {
    if(emailController.text.isEmpty || passwordController.text.isEmpty) {

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
    final url = Uri.parse("https://springboot-kafe.onrender.com/users/register-step1");
    final Map<String, dynamic> userData = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
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
          MaterialPageRoute(builder: (context) => RegScreen2(email: email))
        );
      } else {
        if (response.statusCode == 409) {
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
                    Center(
                      child: Text('Цю пошту вже зареєстровано. Введіть вільну пошту.',
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
        }
        else {
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
        }
      }
    }
    catch (e){
      print('Error: $e');
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
              padding: const EdgeInsets.symmetric(horizontal: 16), // щоб не прилипало до краю
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, // дозволяє займати всю ширину
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(36),
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
                  'Ваша електронна пошта',
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
                  borderRadius: BorderRadius.circular(36),
                  onTap: () {
                    registerUser();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: const Text(
                      'Далі',
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
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Я вже маю аккаунт',
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

/*Future<void> registerUser() async {
    final url = Uri.parse("https://springboot-kafe.onrender.com/users/register");
    final Map<String, dynamic> userData = {
      "username": phoneController.text,
      "password": passwordController.text,
      "birthdate": birthdateController.text,
      "bonusPoints": 100,
      "phone": phoneController.text,
      "qrCode": "placeholder-qr",
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "aplication/json"},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: Text("Успішно!"),
                content: Text("Реєстрація пройша успішно"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
        );
      } else {
        showError("Помилка: ${response.statusCode}\n${response.body}");
      }
    } catch (e) {
      showError("Сталася помилака: $e");
    }
  }
  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Помилка"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Закрити"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

}
*/