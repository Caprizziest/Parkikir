import 'package:flutter/material.dart';
import 'package:frontend/login.dart';
import 'package:frontend/register.dart';
import 'package:frontend/dashboard.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Poppins',
    ),
    home: const login(),
  ));
}
