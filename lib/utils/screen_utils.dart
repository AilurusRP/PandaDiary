import 'package:flutter/material.dart';

class ScreenUtils {
  static screenH(BuildContext context) => MediaQuery.of(context).size.height;
  static screenW(BuildContext context) => MediaQuery.of(context).size.width;
}
