// lib/models/meal_preview.dart
class MealPreview {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  MealPreview({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory MealPreview.fromJson(Map<String, dynamic> json) {
    return MealPreview(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? 'No name',
      strMealThumb: json['strMealThumb'] ?? '',
    );
  }
}