import 'package:calai/models/nutrition_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:calai/services/calai_firestore_service.dart';
import 'package:calai/models/food_model.dart';
import 'package:calai/enums/food_enums.dart';
import 'package:calai/providers/entry_streams_provider.dart';

class LoggedFoodView extends ConsumerStatefulWidget {
  final FoodLog foodLog; // Removed nullability since we are editing a log

  const LoggedFoodView({super.key, required this.foodLog});

  @override
  ConsumerState<LoggedFoodView> createState() => _LoggedFoodPageState();
}

class _LoggedFoodPageState extends ConsumerState<LoggedFoodView> {
  late double _servingsCount;

  @override
  void initState() {
    super.initState();
    // Initialize the UI with the values from the existing log
    _servingsCount = widget.foodLog.amount;
  }

  void _onUpdateLog(FoodLog updatedLog) {
    // Pass the original log and the modified log to calculate the delta in Firestore
    ref.read(calaiServiceProvider).updateFoodEntry(
      widget.foodLog,
      updatedLog,
    );
    Navigator.pop(context);
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  Widget _buildMeasurementTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // We display the portion saved in the FoodLog as the primary tab
          _TabButton(
            label: _capitalize(widget.foodLog.portion),
            isActive: true, // Always active since it's the only available context
            onTap: () {
              // Logic stays here as it's the fixed reference point
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = widget.foodLog.imageUrl != null;

    // 1. Calculate the Ratio
    // If original amount was 100 and new is 200, ratio is 2.0
    final double ratio = _servingsCount / (widget.foodLog.amount > 0 ? widget.foodLog.amount : 1.0);

    // 2. Create the Preview Log with recalculated macros
    final previewLog = widget.foodLog.copyWith(
      amount: _servingsCount,
      calories: (widget.foodLog.calories * ratio).toInt(),
      protein: (widget.foodLog.protein * ratio).toInt(),
      carbs: (widget.foodLog.carbs * ratio).toInt(),
      fats: (widget.foodLog.fats * ratio).toInt(),
      sugar: (widget.foodLog.sugar * ratio).toInt(),
      fiber: (widget.foodLog.fiber * ratio).toInt(),
      sodium: (widget.foodLog.sodium * ratio).toInt(),
      // Recalculate other nutrients list if it exists
      otherNutrients: widget.foodLog.otherNutrients.map((n) => n.copyWith(
        amount: n.amount * ratio,
      )).toList(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Image
          if (hasImage)
            Positioned(
              top: 0, left: 0, right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Image.network(widget.foodLog.imageUrl!, fit: BoxFit.cover),
            ),

          // Content Card
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: hasImage ? MediaQuery.of(context).size.height * 0.4 : 0),
              child: Container(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * (hasImage ? 0.6 : 1.0)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: hasImage ? const BorderRadius.vertical(top: Radius.circular(30)) : null,
                ),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!hasImage) SizedBox(height: MediaQuery.of(context).padding.top + 60),
                    _buildTimestamp(),
                    const SizedBox(height: 10),
                    _buildFoodTitle(),
                    const SizedBox(height: 25),

                    _buildSectionLabel(theme, "Measurement"),
                    const SizedBox(height: 10),
                    _buildMeasurementTabs(), // ✅ Displaying the portion tab here
                    const SizedBox(height: 14),
                    _buildServingsRow(theme),

                    const SizedBox(height: 22),
                    _buildCaloriesCard(theme, previewLog),
                    const SizedBox(height: 18),
                    _buildMacroRow(previewLog),

                    if (widget.foodLog.healthScore != null) ...[
                      const SizedBox(height: 18),
                      _buildHealthScore(widget.foodLog.healthScore!)
                    ],

                    const SizedBox(height: 26),
                    _buildSectionLabel(theme, "Total Nutrition"),
                    const SizedBox(height: 10),
                    _buildDetailedNutritionList(previewLog),
                  ],
                ),
              ),
            ),
          ),

          // App Bar
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0, right: 0,
            child: _buildTransparentAppBar(hasImage),
          ),

          // Bottom Buttons
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildBottomActionButtons(previewLog),
          ),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildTimestamp() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        DateFormat.jm().format(widget.foodLog.timestamp),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildFoodTitle() {
    return Text(
      widget.foodLog.name,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
    );
  }

  Widget _buildServingsRow(ThemeData theme) => Row(
    children: [
      const Text("Number of Servings", style: TextStyle(fontWeight: FontWeight.bold)),
      const Spacer(),
      _ServingsInputBox(
        value: _servingsCount,
        onChanged: (v) => setState(() => _servingsCount = v),
      ),
    ],
  );

  Widget _buildHealthScore(int score) {
    final color = score >= 8 ? Colors.green : (score >= 5 ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Health Score', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('$score/10', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: score / 10,
            backgroundColor: color.withOpacity(0.1),
            color: color,
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard(ThemeData theme, FoodLog data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("CALORIES", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text("${data.calories}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(FoodLog data) => Row(
    children: [
      Expanded(child: _MacroTile(value: "${data.protein}g", nutritionType: NutritionType.protein)),
      const SizedBox(width: 8),
      Expanded(child: _MacroTile(value: "${data.carbs}g", nutritionType: NutritionType.carbs)),
      const SizedBox(width: 8),
      Expanded(child: _MacroTile(value: "${data.fats}g", nutritionType: NutritionType.fats)),
    ],
  );

  Widget _buildDetailedNutritionList(FoodLog data) => Column(
    children: [
      _NutriRow("Sugar", "${data.sugar}g"),
      _NutriRow("Fiber", "${data.fiber}g"),
      _NutriRow("Sodium", "${data.sodium}mg"),
      for (var n in data.otherNutrients) _NutriRow(n.name, "${n.amount.toStringAsFixed(1)}${n.unit}"),
    ],
  );

  Widget _NutriRow(String name, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(name, style: const TextStyle(color: Colors.grey)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
    ),
  );

  Widget _buildTransparentAppBar(bool hasImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: hasImage ? Colors.white : Colors.black, size: 20),
          ),
          Text("Nutrients", style: TextStyle(fontWeight: FontWeight.bold, color: hasImage ? Colors.white : Colors.black)),
          const SizedBox(width: 40), // Spacer
        ],
      ),
    );
  }

  Widget _buildBottomActionButtons(FoodLog log) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: const Text("Fix result", style: TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _onUpdateLog(log),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: const Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) => Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey));
}

class _MacroTile extends StatelessWidget {
  final String value;
  final NutritionType nutritionType;
  const _MacroTile({required this.value, required this.nutritionType});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiary,
                  shape: BoxShape.circle,
                ),
                child: Icon(nutritionType.icon, color: nutritionType.color, size: 12),
              ),
              const SizedBox(width: 10),
              Text(nutritionType.label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isActive ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}


class _ServingsInputBox extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _ServingsInputBox({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_ServingsInputBox> createState() => _ServingsInputBoxState();
}

class _ServingsInputBoxState extends State<_ServingsInputBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize with the current value
    _controller = TextEditingController(text: _formatValue(widget.value));
  }

  // Helper to remove trailing .0 for cleaner display
  String _formatValue(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 1);

  @override
  void didUpdateWidget(_ServingsInputBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller if value changes externally (but not if user is typing)
    if (oldWidget.value != widget.value) {
      final newText = _formatValue(widget.value);
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade400),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              onChanged: (v) {
                final parsed = double.tryParse(v);
                if (parsed != null) widget.onChanged(parsed);
              },
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.edit, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}