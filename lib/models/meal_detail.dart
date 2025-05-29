// lib/models/meal_detail.dart
class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  // Anda bisa menambahkan field lain jika diperlukan, misal strCategory, strArea, strTags, strYoutube, dan ingredients (strIngredient1, strMeasure1, dst.)

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    return MealDetail(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? 'No name',
      strMealThumb: json['strMealThumb'] ?? '',
      strInstructions: json['strInstructions'] ?? 'No instructions available.',
    );
  }
}