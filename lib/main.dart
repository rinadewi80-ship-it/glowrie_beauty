import 'package:flutter/material.dart';
import 'screens/main_product_screen.dart';

void main() {
  runApp(const GlowrieBeautyApp());
}

class GlowrieBeautyApp extends StatelessWidget {
  const GlowrieBeautyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glowrie Beauty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF0F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF0F2),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainProductScreen(),
    );
  }
}