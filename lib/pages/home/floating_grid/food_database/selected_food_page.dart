import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Update these imports to match your file structure
import 'package:calai/api/food_api.dart';
import 'package:calai/core/constants/app_sizes.dart';
import 'package:calai/data/global_data.dart';
import 'package:calai/models/food.dart';

class SelectedFoodPage extends ConsumerStatefulWidget {
  final String? foodId;

  const SelectedFoodPage({super.key, required this.foodId});

  @override
  ConsumerState<SelectedFoodPage> createState() => _SelectedFoodPageState();
}

class _SelectedFoodPageState extends ConsumerState<SelectedFoodPage> {
  bool _isLoading = true;
  String? _errorMessage;
  Food? _foodItem;

  // Selection State
  FoodPortionItem? _selectedPortion;
  bool _isGramsMode = true;
  double _servingsCount = 100;

  @override
  void initState() {
    super.initState();
    _fetchFoodDetails();
  }

  Future<void> _fetchFoodDetails() async {
    setState(() => _isLoading = true);
    if (widget.foodId == null) {
      setState(() {
        _errorMessage = "Invalid Food ID";
        _isLoading = false;
      });
      return;
    }

    try {
      final foods = await FoodApi.getFoodsByIds([widget.foodId!]);
      if (foods.isEmpty) throw Exception("Food not found");

      if (mounted) {
        setState(() {
          _foodItem = foods.first;

          if (_foodItem!.portions.isNotEmpty) {
            final portions = _foodItem!.portions.cast<FoodPortionItem>();
            _selectedPortion = portions.firstWhere(
                  (p) => !p.label.toLowerCase().contains("quantity not specified"),
              orElse: () => portions.first,
            );

            _isGramsMode = false;
            _servingsCount = 1;
          } else {
            _isGramsMode = true;
            _servingsCount = 100;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Could not load food details";
          _isLoading = false;
        });
      }
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  // --- Actions ---

  void _onLogFood(FoodLog previewLog) {
    ref.read(globalDataProvider.notifier).logFoodEntry(
      previewLog,
      FoodSource.foodDatabase,
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Logged ${previewLog.calories} kcal of ${previewLog.name}")),
    // );

    Navigator.pop(context);
  }

  // --- Dynamic UI Helper ---
  Widget _buildMeasurementTabs() {
    final portions = _foodItem?.portions.cast<FoodPortionItem>() ?? [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _TabButton(
            label: "G",
            isActive: _isGramsMode,
            onTap: () => setState(() {
              _isGramsMode = true;
              _selectedPortion = null;
              _servingsCount = 100;
            }),
          ),
          const SizedBox(width: 10),
          ...portions.map((portion) {
            final bool isActive = !_isGramsMode && _selectedPortion == portion;
            String unit = portion.unitOnly;
            if (unit == "per100") unit = "Standard";
            final displayLabel = _capitalize(unit);

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _TabButton(
                label: displayLabel,
                isActive: isActive,
                onTap: () => setState(() {
                  _isGramsMode = false;
                  _selectedPortion = portion;
                  if (_servingsCount >= 10) _servingsCount = 1;
                }),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_errorMessage != null) return Scaffold(body: Center(child: Text(_errorMessage!)));
    if (_foodItem == null) return const SizedBox.shrink();

    final FoodLog previewLog = _foodItem!.createLog(
      amount: _servingsCount,
      unit: _isGramsMode ? "Grams" : (_selectedPortion?.label ?? "Serving"),
      gramWeight: _isGramsMode ? 1.0 : (_selectedPortion?.gramWeight ?? 100.0),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFoodTitle(),
                    const SizedBox(height: 25),
                    _buildSectionLabel(theme, "Measurement"),
                    const SizedBox(height: 10),
                    _buildMeasurementTabs(),
                    const SizedBox(height: 14),
                    _buildServingsRow(theme),
                    const SizedBox(height: 22),
                    _buildCaloriesCard(theme, previewLog),
                    const SizedBox(height: 18),
                    _buildMacroRow(previewLog),
                    const SizedBox(height: 26),
                    _buildSectionLabel(theme, "Other nutrition facts"),
                    const SizedBox(height: 10),
                    _buildDetailedNutritionList(previewLog),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            _buildLogButton(previewLog),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
          const SizedBox(width: 12),
          const Expanded(child: Center(child: Text("Selected food", style: TextStyle(fontWeight: FontWeight.w700)))),
          const SizedBox(width: 12),
          _CircleButton(icon: Icons.more_horiz, onTap: () => debugPrint("Options")),
        ],
      ),
    );
  }

  Widget _buildFoodTitle() {
    // ✅ FIX 1: Watch the StreamProvider directly for instant updates
    final savedFoodsAsync = ref.watch(savedFoodsStreamProvider);

    // ✅ FIX 2: Check if this food's ID exists in the saved list
    final bool isSaved = savedFoodsAsync.maybeWhen(
      data: (foods) => foods.any((f) => f.id == _foodItem!.id),
      orElse: () => false,
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            _foodItem!.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            final notifier = ref.read(globalDataProvider.notifier);
            if (isSaved) {
              notifier.unsaveFood(_foodItem!.id);
            } else {
              notifier.saveFood(_foodItem!);
            }
          },
          child: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_outline,
            color: isSaved ? Colors.black : Colors.grey,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) => Text(
    label,
    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: theme.hintColor),
  );

  Widget _buildServingsRow(ThemeData theme) => Row(
    children: [
      Text("Number of servings", style: TextStyle(fontWeight: FontWeight.w700, color: theme.hintColor)),
      const Spacer(),
      _ServingsInputBox(
        value: _servingsCount,
        isGrams: _isGramsMode,
        onChanged: (v) => setState(() => _servingsCount = v),
      ),
    ],
  );

  Widget _buildCaloriesCard(ThemeData theme, FoodLog data) {
    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.splashColor, width: 0.5),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            height: 50, width: 50,
            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.local_fire_department, size: 25),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Calories", style: TextStyle(fontSize: 12, color: theme.hintColor, fontWeight: FontWeight.w600)),
              Text("${data.calories}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(FoodLog data) => Row(
    children: [
      Expanded(child: _MacroTile(label: "Protein", value: "${data.protein}g", iconColor: Colors.redAccent, iconData: Icons.set_meal_outlined)),
      const SizedBox(width: 8),
      Expanded(child: _MacroTile(label: "Carbs", value: "${data.carbs}g", iconColor: Colors.orangeAccent, iconData: Icons.bubble_chart)),
      const SizedBox(width: 8),
      Expanded(child: _MacroTile(label: "Fats", value: "${data.fats}g", iconColor: Colors.blueAccent, iconData: Icons.oil_barrel)),
    ],
  );

  Widget _buildDetailedNutritionList(FoodLog data) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        for (final nutrient in data.otherNutrients)
          if (nutrient.amount > 0)
            _NutritionRow(
              name: nutrient.name,
              value: "${nutrient.amount.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '')}${nutrient.unit}",
            ),
      ],
    ),
  );

  Widget _buildLogButton(FoodLog previewLog) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
    child: SizedBox(
      height: 56, width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
        onPressed: () => _onLogFood(previewLog),
        child: const Text("Log", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white)),
      ),
    ),
  );
}

// ============================================================================
// SUB-WIDGETS
// ============================================================================

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.onTertiary.withOpacity(0.6),
        ),
        child: Icon(icon),
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
          color: isActive ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isActive ? Colors.white : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

class _ServingsInputBox extends StatefulWidget {
  final double value;
  final bool isGrams;
  final ValueChanged<double> onChanged;

  const _ServingsInputBox({
    required this.value,
    required this.isGrams,
    required this.onChanged,
  });

  @override
  State<_ServingsInputBox> createState() => _ServingsInputBoxState();
}

class _ServingsInputBoxState extends State<_ServingsInputBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
  }

  @override
  void didUpdateWidget(covariant _ServingsInputBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.isGrams != widget.isGrams) {
      if (double.tryParse(_controller.text) != widget.value) {
        _controller.text = _formatValue(widget.value);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (widget.isGrams) return value.toStringAsFixed(0);
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }

  void _onCommit(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return;
    final parsed = double.tryParse(cleaned);
    if (parsed == null) return;
    final newValue = widget.isGrams ? parsed.roundToDouble().clamp(1, 9999) : parsed.clamp(0.1, 999);
    widget.onChanged(newValue.toDouble());
    _controller.text = _formatValue(newValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade400),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(decimal: !widget.isGrams, signed: false),
              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              onSubmitted: _onCommit,
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

class _MacroTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;
  final Color iconColor;

  const _MacroTile({required this.label, required this.value, required this.iconData, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: theme.splashColor, width: 0.5),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
                padding: const EdgeInsets.all(5.0),
                child: Icon(iconData, size: 18, color: iconColor),
              ),
              const SizedBox(width: 5),
              Text(label, style: TextStyle(color: theme.hintColor, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String name;
  final String value;

  const _NutritionRow({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}