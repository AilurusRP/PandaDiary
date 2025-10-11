import 'package:flutter/material.dart';
import 'package:panda_diary/UI/home_page.dart';
import 'package:panda_diary/constants/package_name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,),
      ),
      title: appName,
      home: const DiaryHomePage(title: appName),
    );
  }
}
