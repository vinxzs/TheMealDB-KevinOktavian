// lib/screens/meal_detail_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealName;
  final String mealImageUrl; // Digunakan jika gambar detail gagal dimuat
  final String heroTag;

  MealDetailScreen({
    required this.mealId,
    required this.mealName,
    required this.mealImageUrl,
    required this.heroTag,
  });

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<MealDetail> _mealDetailFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _mealDetailFuture = _apiService.fetchMealDetails(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    // Sesuai dokumen, "Tampilan Informasi Detail, tanpa App Bar." [cite: 2, 6]
    // kemudian "*Boleh ditambahkan App Bar" [cite: 6]
    // Default ke tanpa App Bar untuk mencocokkan gambar utama[cite: 2].
    bool showAppBar = false;

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
        title: Text(widget.mealName),
      )
          : null,
      body: FutureBuilder<MealDetail>(
        future: _mealDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final mealDetail = snapshot.data!;
            return CustomScrollView( // Menggunakan CustomScrollView untuk efek collapse jika diperlukan
              slivers: <Widget>[
                if (!showAppBar) // Jika tidak ada AppBar, judul bisa di atas gambar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0), // Tambahkan padding atas
                      child: Text(
                        mealDetail.strMeal,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left, // Sesuai gambar detail [cite: 2]
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Hero( // Hero Animation [cite: 2]
                    tag: widget.heroTag, // Tag harus sama persis
                    child: Image.network(
                      mealDetail.strMealThumb.isNotEmpty ? mealDetail.strMealThumb : widget.mealImageUrl,
                      fit: BoxFit.cover,
                      height: 280, // Sesuaikan tinggi gambar
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network( // Fallback ke image URL dari list jika detail gagal
                            widget.mealImageUrl,
                            fit: BoxFit.cover,
                            height: 280,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 280,
                                  color: Colors.grey[200],
                                  child: Center(child: Icon(Icons.broken_image, size: 60, color: Colors.grey)),
                                ),
                          ),
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 280,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showAppBar) // Jika ada AppBar, tampilkan judul di sini juga jika ingin
                          Text(
                            mealDetail.strMeal,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (showAppBar) SizedBox(height: 16),
                        Text(
                          "Instructions", // Judul untuk instruksi
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          mealDetail.strInstructions.replaceAll(r'\r\n', '\n\n').trim(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Meal details not found.'));
          }
        },
      ),
    );
  }
}