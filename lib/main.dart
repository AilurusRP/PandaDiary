import 'package:flutter/material.dart';
import 'package:panda_diary/UI/home_page.dart';

void main() {
  runApp(const MyApp());
}

int _blackPrimaryValue = 0xFF000000;
MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: const Color(0xFF000000),
    100: const Color(0xFF000000),
    200: const Color(0xFF000000),
    300: const Color(0xFF000000),
    400: const Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: const Color(0xFF000000),
    700: const Color(0xFF000000),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panda Diary',
      theme: ThemeData(
          primarySwatch: primaryBlack),
      home: const DiaryHomePage(title: 'Panda Diary'),
    );
  }
}
