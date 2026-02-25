import 'package:calai/api/food_api.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/edit_value_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:calai/services/calai_firestore_service.dart';
import 'package:calai/models/food_model.dart';
import 'package:calai/enums/food_enums.dart';

class LoggedFoodView extends ConsumerStatefulWidget {
  final FoodLog? foodLog;

  const LoggedFoodView({super.key, this.foodLog});

  @override
  ConsumerState<LoggedFoodView> createState() => _LoggedFoodPageState();
}

class _LoggedFoodPageState extends ConsumerState<LoggedFoodView> {
  late double _servingsCount;
  late FoodLog _tempLog;
  bool _isSubmitting = false;

  // Helper to check if we are creating or editing
  bool get isNewEntry => widget.foodLog == null || widget.foodLog?.id == null;

  @override
  void initState() {
    super.initState();
    // If null, start with a fresh empty log
    _tempLog = widget.foodLog ?? FoodLog.empty();
    _servingsCount = _tempLog.amount;
  }

  void onCaloriesChanged(double newVal) {
    setState(() {
      _tempLog = _tempLog.copyWith(calories: newVal);
    });
  }

  void _onSave(FoodLog finalLog) async {
    // 1. Guard against empty names and concurrent taps
    if (finalLog.name.trim().isEmpty) {
      return;
    }
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final service = ref.read(calaiServiceProvider);
      final navigator = Navigator.of(context);
      if (isNewEntry) {
        final newFoodId = DateTime.now().millisecondsSinceEpoch.toString();
        final masterFood = Food.empty().copyWith(
          id: newFoodId,
          name: finalLog.name,
          calories: finalLog.calories,
          protein: finalLog.protein,
          carbs: finalLog.carbs,
          fats: finalLog.fats,
          sugar: finalLog.sugar,
          fiber: finalLog.fiber,
          sodium: finalLog.sodium,
          imageUrl: finalLog.imageUrl,
          source: SourceType.foodUpload.name,
          water: finalLog.water,
          portion: [FoodPortionItem(label: 'serving', gramWeight: 100)]
        );

        await Future.wait([
          service.saveFood(masterFood),
          service.logFoodEntry(
            finalLog.copyWith(foodId: newFoodId),
            SourceType.foodUpload,
          ),
        ]);
      } else {
        // Updating an existing log entry
        await service.updateFoodEntry(widget.foodLog!, finalLog);
      }

      if (mounted) navigator.pop();
    } catch (e) {
      debugPrint("❌ Save Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error saving. Please check your connection."),
          ),
        );
      }
    }
  }

  Widget _buildFoodTitle() {
    if (isNewEntry) {
      return TextField(
        decoration: const InputDecoration(
          hintText: "Enter food name",
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
          ),
        ),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        onChanged: (val) => setState(() => _tempLog = _tempLog.copyWith(name: val)),
      );
    }
    return Text(
      _tempLog.name,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
    );
  }

  void _showEditModal({
    required String title,
    required double initialValue,
    required Function(double) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => EditModal(
        initialValue: initialValue,
        title: title,
        label: title,
        color: Theme.of(context).colorScheme.primary,
        onDone: (newValue) {
          onSave(newValue);
          Navigator.pop(context);
        },
      ),
    );
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
            label: _capitalize(_tempLog.portion),
            isActive:
                true, // Always active since it's the only available context
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
    final hasImage = _tempLog.imageUrl != null;
    final bool isNameValid = _tempLog.name.trim().isNotEmpty;

    // 1. Calculate the Ratio
    // If original amount was 100 and new is 200, ratio is 2.0
    final double ratio =
        _servingsCount / (_tempLog.amount > 0 ? _tempLog.amount : 1.0);

    // 2. Create the Preview Log with recalculated macros
    final previewLog = _tempLog.copyWith(
      amount: _servingsCount,
      calories: (_tempLog.calories * ratio),
      protein: (_tempLog.protein * ratio),
      carbs: (_tempLog.carbs * ratio),
      fats: (_tempLog.fats * ratio),
      sugar: (_tempLog.sugar * ratio),
      fiber: (_tempLog.fiber * ratio),
      sodium: (_tempLog.sodium * ratio),
      // Recalculate other nutrients list if it exists
      otherNutrients: _tempLog.otherNutrients
          .map((n) => n.copyWith(amount: n.amount * ratio))
          .toList(),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Header Image
          if (hasImage)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Image.network(_tempLog.imageUrl!, fit: BoxFit.cover),
            ),

          // Content Card
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: hasImage ? MediaQuery.of(context).size.height * 0.4 : 0,
              ),
              child: Container(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height *
                      (hasImage ? 0.6 : 1.0),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: hasImage
                      ? const BorderRadius.vertical(top: Radius.circular(30))
                      : null,
                ),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!hasImage)
                      SizedBox(height: MediaQuery.of(context).padding.top + 60),
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
                    _buildCaloriesCard(context, previewLog),
                    const SizedBox(height: 18),
                    _buildMacroRow(previewLog),

                    if (_tempLog.healthScore != null) ...[
                      const SizedBox(height: 18),
                      _buildHealthScore(_tempLog.healthScore!),
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
            left: 0,
            right: 0,
            child: _buildTransparentAppBar(hasImage),
          ),

          // Bottom Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ConfirmationButtonWidget(
              onConfirm: () => _onSave(previewLog),
              text: isNewEntry ? "Log Food" : "Update Entry",
              enabled: isNameValid && !_isSubmitting,
            ),
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        DateFormat.jm().format(_tempLog.timestamp),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildServingsRow(ThemeData theme) => Row(
    children: [
      const Text(
        "Number of Servings",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const Spacer(),
      _ServingsInputBox(
        value: _servingsCount,
        onChanged: (v) => setState(() => _servingsCount = v),
      ),
    ],
  );

  Widget _buildHealthScore(double score) {
    final color = score >= 8
        ? Colors.green
        : (score >= 5 ? Colors.orange : Colors.red);
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
              const Text(
                'Health Score',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$score/10',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
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

  Widget _buildCaloriesCard(BuildContext context, FoodLog data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.black,
                size: 28,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Calories",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ✅ This now displays the local state value
                  Text(
                    "${data.calories.round()}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showEditModal(
                title: 'Calories',
                initialValue: data.calories,
                onSave: (val) =>
                    setState(() => _tempLog = _tempLog.copyWith(calories: val)),
              ),
              child: Icon(Icons.edit, size: 16, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(FoodLog data) => Row(
    children: [
      Expanded(
        child: _MacroTile(
          value: "${data.protein.round()}g",
          nutritionType: NutritionType.protein,
          onEdit: () => _showEditModal(
            title: 'Protein',
            initialValue: data.protein,
            onSave: (val) =>
                setState(() => _tempLog = _tempLog.copyWith(protein: val)),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _MacroTile(
          value: "${data.carbs.round()}g",
          nutritionType: NutritionType.carbs,
          onEdit: () => _showEditModal(
            title: 'Carbs',
            initialValue: data.carbs,
            onSave: (val) =>
                setState(() => _tempLog = _tempLog.copyWith(carbs: val)),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _MacroTile(
          value: "${data.fats.round()}g",
          nutritionType: NutritionType.fats,
          onEdit: () => _showEditModal(
            title: 'Fats',
            initialValue: data.fats,
            onSave: (val) =>
                setState(() => _tempLog = _tempLog.copyWith(fats: val)),
          ),
        ),
      ),
    ],
  );

  Widget _buildDetailedNutritionList(FoodLog data) => Column(
    children: [
      _nutriRow("Sugar", "${data.sugar.toStringAsFixed(2)}g"),
      _nutriRow("Fiber", "${data.fiber.toStringAsFixed(2)}g"),
      _nutriRow("Sodium", "${data.sodium.toStringAsFixed(2)}mg"),
      for (var n in data.otherNutrients)
        _nutriRow(n.name, "${n.amount.toStringAsFixed(1)}${n.unit}"),
    ],
  );

  Widget _nutriRow(String name, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
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
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
          ),
          Text(
            "Nutrients",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: hasImage ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 40), // Spacer
        ],
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) => Text(
    label,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );
}

class _MacroTile extends StatelessWidget {
  final String value;
  final NutritionType nutritionType;
  final VoidCallback? onEdit; // Added callback for the pencil tap

  const _MacroTile({
    required this.value,
    required this.nutritionType,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ✅ Use Stack to pin the icon to the corner
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align text to start
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onTertiary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      nutritionType.icon,
                      color: nutritionType.color,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    nutritionType.label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        // ✅ The Positioned Pencil Icon
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: onEdit,
            child: Icon(
              Icons.edit,
              size: 12, // Slightly smaller for the macro tiles
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
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
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isActive
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _ServingsInputBox extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _ServingsInputBox({required this.value, required this.onChanged});

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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
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
