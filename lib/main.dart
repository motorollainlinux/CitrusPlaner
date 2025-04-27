import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class AppTheme {
  // Цвета
  static const Color textColor = Color(0xFFFFEFE0);
  static const Color coffe400 = Color(0xFF472B13);
  static const Color coffe300 = Color(0xFF5C3719);
  static const Color coffe200 = Color(0xFF854F24);
  static const Color coffe100 = Color(0xFF995C29);
  static const Color interactObj = Color(0xFFAD682F);
  static const Color buttonColor = Color(0xFFA86931);
  static const Color buttonActive = Color(0xFFEC9345);
  
  // Текст
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 32 / 32,
    letterSpacing: 0,
    color: textColor,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 29,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 29 / 29,
    letterSpacing: 0,
    color: textColor,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 26,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 26 / 26,
    letterSpacing: 0,
    color: textColor,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 23,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 23 / 23,
    letterSpacing: 0,
    color: textColor,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 20 / 20,
    letterSpacing: 0,
    color: textColor,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 18,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 18 / 18,
    letterSpacing: 0,
    color: textColor,
  );

  static const TextStyle normalText = TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono', 
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 16 / 16,
    letterSpacing: 0,
    color: textColor,
  );

  static const TextStyle textsmall = TextStyle(
    fontSize: 14,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    height: 14 / 14,
    letterSpacing: 0,
    color: textColor,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'RobotoMono',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 14,
    letterSpacing: 0,
    color: Color(0xFF726F6F),
  );
  // Отступы
  static const double buttonPadding = 15.0;

  // Иконки
  static const Icon searchIcon = Icon(Icons.search, color: textColor);
  static const Icon settingsIcon = Icon(Icons.settings, color: textColor);
  static const Icon addIcon = Icon(Icons.add, color: textColor);
  static const Icon newFolderIcon = Icon(Icons.create_new_folder, color: textColor);
  static const Icon deleteIcon = Icon(Icons.delete, color: textColor);
  static const Icon calendarIcon = Icon(Icons.calendar_month, color: textColor);
  static const Icon alarmIcon = Icon(Icons.notification_add, color: textColor);
  static const Icon timeIcon = Icon(Icons.access_time, color: textColor);
  static const Icon graphIcon = Icon(Icons.share, color: textColor);
  static Image logoIcon = Image.asset( 'assets/logo.png', width: 74, height: 74);
  // Кнопки
  static ButtonStyle textButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return buttonActive;
        }
        if (states.contains(WidgetState.hovered)) {
          return interactObj;
        }
        return buttonColor;
      },
    ),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    padding: WidgetStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(vertical: buttonPadding, horizontal: buttonPadding),
    ),
  );
  static const InputDecoration searchInputDecoration = InputDecoration(
    hintText: "Search...",
    hintStyle: hintText,
    fillColor: buttonActive,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(35.0)),
      borderSide: BorderSide(color: coffe200, width: 3),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    suffixIcon: searchIcon,
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.coffe200,
      appBar: AppBar(
        leading: AppTheme.logoIcon,
        backgroundColor: AppTheme.coffe300,
      ),
    );
  }
}
