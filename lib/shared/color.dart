import 'package:flutter/material.dart';

class AppColor {
  static final primaryColor = Color(0xFF424242);
  static final buttonColor = Color(0xFFF1BB37);
}

class AppShape {
  static final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: AppColor.buttonColor));
}
