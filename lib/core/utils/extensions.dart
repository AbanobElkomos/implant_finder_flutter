import 'package:flutter/material.dart';

extension StringExtensions on String {
  String get capitalize => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  bool get isEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isPhone => RegExp(r'^\+?[0-9]{10,15}$').hasMatch(this);
}

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

extension ListExtensions<T> on List<T> {
  List<T> get unique => toSet().toList();
}