import 'package:flutter/material.dart';

abstract class AppButtonStyle {
  static final ButtonStyle linkButtonStyle = ButtonStyle(
      foregroundColor:
          MaterialStateProperty.all(const Color.fromRGBO(1, 180, 228, 1)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      )));
}
