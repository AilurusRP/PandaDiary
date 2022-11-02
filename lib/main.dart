import 'package:flutter/material.dart';
import 'package:panda_diary/UI/home_page.dart';

import 'constants/theme_color.dart';

void main() {
  runApp(const MyApp());
}

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
