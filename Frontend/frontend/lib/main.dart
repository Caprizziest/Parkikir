import 'package:flutter/material.dart';
import 'package:frontend/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Poppins',
    ),
    home: const login(),
  ));
}
