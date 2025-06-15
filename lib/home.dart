import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'qr.dart';
import 'history.dart';
import 'acc.dart';
import 'menu.dart';
//import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  HomeScreen({required this.email});

  @override
  HomeScreenState createState() => HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {
  int bonusPoints = 0;
  int id = 0;

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
        final int getBonusPoints = data['bonusPoints'] ?? 0;
        setState(() {
          bonusPoints = getBonusPoints;
          id = getId;
        });
      } else {
        //шось придумаю
      }

    }
    catch (e){
      //щось придумаю
    }

  }//клас головної сторінки

  @override
  void initState() {
    super.initState();
    infoUser(widget.email);
  }
  @override
  Widget build(BuildContext context) { //малюємо візуал
    return Scaffold( //каркас, фундамент, основа, база, архітектура сторінки
      backgroundColor: Colors.white, //фоно білий
      bottomNavigationBar: BottomNavigationBar(//бар з кнопками навігації
        backgroundColor: Color(0xFFEBA2AC),//фон бару з кнопками навігації
        type: BottomNavigationBarType.fixed, //фіксовані іконки, щоб не змінювався розмір та колір для обраної
        selectedFontSize: 0,//розмір підпису обраного елементу. 0 щоб тексту не було
        unselectedFontSize: 0,//розмір підпису не обраного елементу. 0 щоб тексту не було
        iconSize: 0, //дефолтний розмір іконок. 0 бо для кожної іконки будемо задавати самостійно. інакше будуть зайві відступи
        items: [ //об'єкти. це зручно, щоб потім задавати дію для кожної кнопки за індексом
          BottomNavigationBarItem(//описуємо об'єкт
            icon: SizedBox(//огортаємо в бокс якому можна задати розмір
              height: 64, //висота боксу 64
              child: Center(//центруємо дитину
                child: Image.asset('assets/images/home.png', width: 54, height: 54), //додаємо ще одну дитину, у яку вставляємо фото та його розміри. оскільки ми використовуємо центр, вона буде центруватися по висоті боксу
              ),
            ),
            label: '', //підпис під іконку. оскільки нам не потрібен підпис залишаємо лапки порожні
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
        ],//всередині робимо ще 4 аналогічні об'єкти, ліше для центральної кнопки робимо розмір 85*85, та висоту боксу 85
        currentIndex: 0, //поточний активний об'єкт 0, тобто ми на сторінці на яку можна перейти натиснувши на об'єкт з індексом 0
        onTap: (index) { //метод який запускає наслідки при натисненні. всередині описуємо самі наслідки
          if (index == 1) {//оскільки ми на 0, то починаємо з опису перехду на вільні сторінки(від 1 до 4). якщо індекс натиснутого об'єкту 1 виконуємо наступну дію
            Navigator.push(//навігація між сторінками, задає команду перейти на наступну сторінку
              context,//передає оточення поточної сторінки(тема, розмір екрану та інше)
              MaterialPageRoute(builder: (context) => MenuScreen(
                email: widget.email
              )), //створюємо маршрут та передаємо команду намалювати сторінку menuscreen
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
        },
      ),
      //робимо аналогічно для всих інших кнопок
      body: SafeArea(//основне тіло. огортаємо все внутрішнє в безпечний район(наскільки я розумію це для того щоб ніхто нічого ніде не з'їв)
        child: Column(//робимо дитину та вносимо в неї колонку. щоб мати можливість ставити об'єкти один під оден
          children: [//робимо, тобто групуємо декілька об'єктів
            Container(//перший об'єкт контейнер. тут буде наш кастомний апбар. доречі не впевнена чому саме таким чином його робити, а не методом апп бар
              color: Color(0xFFEBA2AC),//задаємо колір верхньої панелі
              padding: EdgeInsets.all(16),//додємо відступи. всі відступи будуть по 16
              child: Row(//дадаємо дитину рядок
                mainAxisAlignment: MainAxisAlignment.spaceBetween, //розміщуємо елементи рядка з обох боків
                children: [//закидаємо у рядок групу об'єктва
                  const Text(//робимо сталий, незмінний
                    'With Love\ncoffee space',//саме цей текст написано на верхній панелі, текст після \n переноситься на наступний рядок
                    style: TextStyle(fontSize: 20, //стиль тексту, розмір шрифту
                        fontWeight: FontWeight.bold,//стиль шрифту(жирний)
                        color: Colors.white),//колір
                  ),
                  ClipOval(//додаємо овал
                    child: Image.asset(//у овал вводимо дитину, картинку
                      'assets/images/logo.jpeg',//вставляємо наш лого
                      width: 92,//ширина лого
                      height: 76,//висота лого
                      fit: BoxFit.cover,//заповнюємо весь овал, щоб картинка не спотворилась
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                  children: [
                    Column(
                        children:
                        [Padding(//робимо відступ, чесно сама не розуміє у чому різниці падінга та контейнера
                          padding: const EdgeInsets.all(16),//всі внутрішні відступи по 16
                          child: Container(//контейнер
                            padding: const EdgeInsets.all(16),//знову відступи по 16
                            decoration: BoxDecoration(//оздоблення боксу(контейнера)
                              color: Color(0xFFFCE4EC),//колір
                              borderRadius: BorderRadius.circular(35),//заокруглення кутів
                            ),
                            child: Row(//додаємо рядок у контейнер
                              children: [//група
                                Column(//колонка
                                  crossAxisAlignment: CrossAxisAlignment.start,//мабуть розміщення зліва
                                  children: [//незмінний текст(це треба буде змінити, бо кількість бонусів будемо отримувати з бд на сервері
                                    const Text('Бонуси', style: TextStyle(fontSize: 20, //пишемо текст бонуси, стилізуємо
                                        fontWeight: FontWeight.w600,//це наче ступінь жирності
                                        color: Color(0xFF0F0607))
                                    ),
                                    const SizedBox(height: 8),//відступ між об'єктами
                                    Text('$bonusPoints', style: TextStyle(fontSize: 24,//от саме тут будемо вписувати те, шо отримаємо з сервера
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F0607))),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.wifi, size: 20, color: Color(0xFF0F0607)),
                                    SizedBox(height: 4),
                                    Text(
                                      'MadeWithLove',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Color(0xFF0F0607),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => QRScreen(
                                    email: widget.email
                                )),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              height: 234,
                              decoration: BoxDecoration(
                                color: Color(0xFFFCE4EC),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Ваш\nособистий\nQR-код',
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F0607)),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: QrImageView(
                                      data: '$id', // або будь-яке твоє значення
                                      size: 170,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Останні замовлення', style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F0607))),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HistoryScreen(
                                          email: widget.email
                                      )),
                                    );
                                  },
                                  child: const Text('Всі >', style: TextStyle(
                                      color: Color(0xFF893B46), fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFFCE4EC),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Замовлення № id',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF0F0607),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16,),
                        ]
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}