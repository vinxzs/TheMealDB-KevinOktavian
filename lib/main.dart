import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheMealDB App', // Judul aplikasi umum
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Anda bisa mengganti tema warna
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal, // Contoh warna AppBar
          foregroundColor: Colors.white, // Warna teks dan ikon di AppBar
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.teal, // Warna item terpilih di BottomNav
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}