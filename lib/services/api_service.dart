// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_preview.dart';
import '../models/meal_detail.dart';

class ApiService {
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<MealPreview>> fetchMealsByCategory(String category) async {
    String categoryQueryParam = category;
    // Sesuai dokumen, "Vegetarian" menggunakan endpoint "Vegan" [cite: 1]
    if (category.toLowerCase() == 'vegetarian' || category.toLowerCase() == 'vegan') {
      categoryQueryParam = 'Vegan';
    }

    final String url = '$baseUrl/filter.php?c=$categoryQueryParam'; // [cite: 1]
    print('Fetching meals from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['meals'] != null) {
        List<MealPreview> meals = (data['meals'] as List)
            .map((jsonItem) => MealPreview.fromJson(jsonItem))
            .toList();
        return meals;
      } else {
        return []; // Kembalikan list kosong jika tidak ada meals
      }
    } else {
      throw Exception('Failed to load meals for category: $category. Status: ${response.statusCode}');
    }
  }

  Future<MealDetail> fetchMealDetails(String mealId) async {
    final String url = '$baseUrl/lookup.php?i=$mealId';
    print('Fetching meal details from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['meals'] != null && (data['meals'] as List).isNotEmpty) {
        return MealDetail.fromJson((data['meals'] as List)[0]);
      } else {
        throw Exception('Meal details not found for ID: $mealId.');
      }
    } else {
      throw Exception('Failed to load meal details for ID: $mealId. Status: ${response.statusCode}');
    }
  }
}