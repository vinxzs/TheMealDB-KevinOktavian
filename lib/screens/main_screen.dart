// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'category_meals_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Kategori sesuai dengan endpoint yang diminta di dokumen [cite: 1]
  // dan tampilan UI di gambar [cite: 1]
  static const List<String> _categories = ['Seafood', 'Dessert', 'Vegan'];
  static const List<IconData> _categoryIcons = [Icons.set_meal, Icons.cake, Icons.eco];


  List<Widget> _widgetOptions() {
    return _categories
        .map((category) => CategoryMealsScreen(category: category))
        .toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TheMealDB'), // Sesuai gambar di dokumen [cite: 1, 3]
      ),
      body: IndexedStack( // Menggunakan IndexedStack agar state setiap tab terjaga
        index: _selectedIndex,
        children: _widgetOptions(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(_categories.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_categoryIcons[index]),
            label: _categories[index],
          );
        }),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}