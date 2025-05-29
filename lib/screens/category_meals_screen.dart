// lib/screens/category_meals_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_preview.dart';
import 'meal_detail_screen.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String category;

  CategoryMealsScreen({required this.category});

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen>
    with AutomaticKeepAliveClientMixin { // Untuk menjaga state saat tab berubah
  late Future<List<MealPreview>> _mealsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _mealsFuture = _apiService.fetchMealsByCategory(widget.category);
  }

  // Untuk AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Untuk AutomaticKeepAliveClientMixin
    return FutureBuilder<List<MealPreview>>(
      future: _mealsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No meals found in ${widget.category}.'));
        } else {
          final meals = snapshot.data!;
          // Grid View sesuai permintaan [cite: 1]
          return GridView.builder(
            key: PageStorageKey(widget.category), // Untuk menjaga posisi scroll
            padding: const EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 kolom seperti di gambar [cite: 1]
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.8, // Sesuaikan rasio aspek item grid
            ),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              final heroTag = 'mealImage_${meal.idMeal}_${widget.category}'; // Tag Hero yang unik

              return GestureDetector(
                onTap: () {
                  // Navigasi ke detail saat disentuh [cite: 1]
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailScreen(
                        mealId: meal.idMeal,
                        mealName: meal.strMeal,
                        mealImageUrl: meal.strMealThumb,
                        heroTag: heroTag, // Kirim tag Hero
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias, // Untuk memotong gambar sesuai border radius Card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Hero( // Implementasi Hero Animation [cite: 2]
                          tag: heroTag,
                          child: Image.network(
                            meal.strMealThumb,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          meal.strMeal,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}