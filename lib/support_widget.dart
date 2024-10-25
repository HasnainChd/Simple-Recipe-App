import 'package:flutter/material.dart';

class AppWidget {
  static lightStyle() {
    return const TextStyle(
        fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500);
  }

  static boldStyle() {
    return const TextStyle(
        fontSize: 22, color: Colors.black, fontWeight: FontWeight.w800);
  }

  static fullBold() {
    return const TextStyle(
        fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold);
  }
}
