import 'package:flutter/material.dart';
import 'package:panda_diary/UI/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Panda Diary',
      home: DiaryHomePage(title: 'Panda Diary'),
    );
  }
}
