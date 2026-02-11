import 'package:calai/models/nutrition_model.dart';
import 'package:calai/onboarding/onboarding_widgets/calibration_result/health_score_card.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../enums/food_enums.dart';
import '../../../../../models/food_model.dart';

class FoodDetailsPage extends ConsumerStatefulWidget {
  final Food food;
  const FoodDetailsPage({super.key, required this.food});

  @override
  ConsumerState<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends ConsumerState<FoodDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Top Image Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.45,
            child: widget.food.imageUrl != null
                ? Image.network(widget.food.imageUrl!, fit: BoxFit.cover)
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.fastfood, size: 100),
                  ),
          ),

          // 2. Custom App Bar Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: CustomAppBar(
              title: Text("Nutrition"),
              actions: [Icon(Icons.more_vert)],
            ),
          ),

          // 3. Nutrition Details Card
          Positioned.fill(
            top: size.height * 0.4, // Overlap onto the image
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.bookmark_border,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Text(DateFormat.jm().format(widget.food.timestamp.toDate()),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),)
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTitleRow(theme),
                    const SizedBox(height: 20),
                    _buildMainCalories(theme),
                    const SizedBox(height: 20),
                    _buildMacroGrid(theme),
                    const SizedBox(height: 30),
                    HealthScoreCard(progress: widget.food.healthScore!.toDouble() * 0.100, score: 0),
                  ],
                ),
              ),
            ),
          ),

          // 4. Bottom Sticky Action Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomButtons(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildTransparentAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIcon(Icons.arrow_back, onTap: () => Navigator.pop(context)),
          const Text(
            'Nutrition',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              _circleIcon(Icons.ios_share),
              const SizedBox(width: 10),
              _circleIcon(Icons.more_horiz),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildTitleRow(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.food.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => quantity > 1 ? quantity-- : null),
                child: const Icon(Icons.remove, size: 18),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$quantity',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => quantity++),
                child: const Icon(Icons.add, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainCalories(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.black),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calories',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                '${(widget.food.calories * quantity).toInt()}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroGrid(ThemeData theme) {
    return Row(
      children: [
        _macroItem(
          'Protein',
          '${(widget.food.protein * quantity).toInt()}g',
          NutritionType.protein.color,
          NutritionType.protein.icon,
        ),
        _macroItem(
          'Carbs',
          '${(widget.food.carbs * quantity).toInt()}g',
          NutritionType.carbs.color,
          NutritionType.carbs.icon,
        ),
        _macroItem(
          'Fats',
          '${(widget.food.fats * quantity).toInt()}g',
          NutritionType.fats.color,
          NutritionType.fats.icon,
        ),
      ],
    );
  }

  Widget _macroItem(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onTertiary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScore(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Health Score',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('8/10', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.8,
            backgroundColor: Colors.grey[200],
            color: Colors.green,
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Fix Results'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
