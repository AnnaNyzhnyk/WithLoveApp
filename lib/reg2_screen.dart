import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'home.dart';

class RegScreen2 extends StatefulWidget{
  final String email;
  RegScreen2({required this.email});
  @override
  RegScreenState2 createState() => RegScreenState2();
}

class RegScreenState2 extends State<RegScreen2>{
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdateController = TextEditingController();
  final phoneFormatter = MaskTextInputFormatter(
    mask: '+380#########',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  DateTime? selectedDate;


  Future<void>  registerUser() async {
    final email = widget.email;
    if(nameController.text.isEmpty || phoneController.text.isEmpty || birthdateController.text.isEmpty) {

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
    final url = Uri.parse("https://springboot-kafe.onrender.com/users/register-step2");
    final Map<String, dynamic> userData = {
      "email": email,
      "fullName": nameController.text,
      "birthdate": birthdateController.text,
      "phone": phoneFormatter.getMaskedText(),
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        nameController.clear();
        phoneController.clear();
        birthdateController.clear();

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(
              email: email
            ))
        );
      } else {
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
    nameController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
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
                      'Ваше ім'"'"'я',
                      style: TextStyle(
                          color: Color(0xFF0F0607), fontSize: 20
                      ),
                    ),
                  ),
                  TextField(
                    controller: nameController,
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
                      'Номер телефону',
                      style: TextStyle(
                          color: Color(0xFF0F0607), fontSize: 20
                      ),
                    ),
                  ),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [phoneFormatter],
                    decoration: InputDecoration(
                      hintText: '+380#########',
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
                      'День народження',
                      style: TextStyle(
                          color: Color(0xFF0F0607), fontSize: 20
                      ),
                    ),
                  ),
                  TextField(
                    controller: birthdateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Оберіть дату народження',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now()
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        birthdateController.text = "${picked.toIso8601String().substring(0, 10)}";
                      }
                    },
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(35),
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
                          'Зареєструватися',
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