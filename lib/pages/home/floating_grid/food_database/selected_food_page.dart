import 'package:calai/data/global_data.dart';
import 'package:flutter/material.dart';

import '../../../../../api/food_api.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../data/health_data.dart';

class SelectedFoodPage extends StatefulWidget {
  final int foodId;

  const SelectedFoodPage({super.key, required this.foodId});

  @override
  State<SelectedFoodPage> createState() => _SelectedFoodPageState();
}

class _SelectedFoodPageState extends State<SelectedFoodPage> {
  // State Variables
  bool _isLoading = true;
  String? _errorMessage;
  FoodSearchItem? _foodItem;

  // Selection State
  PortionType _selectedPortionType = PortionType.serving;
  FoodPortionItem? _selectedPortion;
  double _servingsCount = 1;

  @override
  void initState() {
    super.initState();
    _fetchFoodDetails();
  }

  /// Fetches food details from the API
  Future<void> _fetchFoodDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final foods = await FoodApi.getFoodsByIds([widget.foodId]);
      if (foods.isEmpty) {
        throw Exception("Food not found");
      }

      final food = foods.first;

      if (mounted) {
        setState(() {
          _foodItem = food;
          _selectedPortionType = PortionType.serving;
          _selectedPortion = _determineBestPortion(food, PortionType.serving);
          _servingsCount = 1;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Selects the best available portion based on the user's selected type
  FoodPortionItem? _determineBestPortion(
      FoodSearchItem food, PortionType type) {
    if (type == PortionType.grams) return null;

    final portions = food.portions;

    try {
      if (type == PortionType.tbsp) {
        return portions.firstWhere((p) {
          final label = p.label.toLowerCase();
          return label.contains("tbsp") || label.contains("tablespoon");
        });
      } else if (type == PortionType.serving) {
        return portions.firstWhere((p) {
          final label = p.label.toLowerCase();
          return label.contains("serving");
        });
      }
    } catch (_) {
      // Fallback if specific portion not found
    }

    return portions.isNotEmpty
        ? portions.first
        : const FoodPortionItem(label: "G", gramWeight: 100);
  }

  /// Calculates nutrient value based on selected portion and servings
  double _calculateNutrientValue(double baseNutrientValue) {
    final portion = _selectedPortion;
    if (portion == null) return baseNutrientValue; // Fallback

    // nutrientsForPortion calculates value for 1 portion
    return _foodItem!.nutrientsForPortion(portion, baseNutrientValue) *
        _servingsCount;
  }

  void _onPortionTypeChanged(PortionType type) {
    if (_foodItem == null) return;

    setState(() {
      _selectedPortionType = type;
      _selectedPortion = _determineBestPortion(_foodItem!, type);

      // Reset servings defaults based on type
      if (_selectedPortionType == PortionType.grams) {
        _servingsCount = 100;
      } else {
        if (_servingsCount < 1) _servingsCount = 1;
      }
    });
  }

  void _onLogFood() {
    if (_foodItem != null) {
      debugPrint("LOG: ${_foodItem!.name} servings=$_servingsCount");
      // Add logging logic here (e.g., GlobalDataNotifier().logFood(...))
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(body: Center(child: Text(_errorMessage!)));
    }

    if (_foodItem == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFoodTitle(),
                    const SizedBox(height: 25),
                    _buildSectionLabel(theme, "Measurement"),
                    const SizedBox(height: 10),
                    _MeasurementTabs(
                      selected: _selectedPortionType,
                      onChanged: _onPortionTypeChanged,
                    ),
                    const SizedBox(height: 14),
                    _buildServingsRow(theme),
                    const SizedBox(height: 22),
                    _buildCaloriesCard(theme),
                    const SizedBox(height: 18),
                    _buildMacroRow(),
                    const SizedBox(height: 26),
                    _buildSectionLabel(theme, "Other nutrition facts"),
                    const SizedBox(height: 10),
                    _buildDetailedNutritionList(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            _buildLogButton(),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Center(
              child: Text(
                "Selected food",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _CircleButton(
            icon: Icons.more_horiz,
            onTap: () => debugPrint("Options tapped"),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTitle() {
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
          onTap: () => GlobalDataNotifier().saveFood(_foodItem!),
          child: const Icon(Icons.bookmark_outline, size: 24),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: theme.hintColor,
      ),
    );
  }

  Widget _buildServingsRow(ThemeData theme) {
    return Row(
      children: [
        Text(
          "Number of servings",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: theme.hintColor,
          ),
        ),
        const Spacer(),
        _ServingsInputBox(
          value: _servingsCount,
          isGrams: _selectedPortionType == PortionType.grams,
          onChanged: (v) => setState(() => _servingsCount = v),
        ),
      ],
    );
  }

  Widget _buildCaloriesCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.splashColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.local_fire_department, size: 25),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Calories",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.hintColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _calculateNutrientValue(_foodItem!.caloriesPer100g)
                      .toStringAsFixed(0),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroRow() {
    return Row(
      children: [
        Expanded(
          child: _MacroTile(
            label: "Protein",
            value:
            "${_calculateNutrientValue(_foodItem!.proteinG).toStringAsFixed(1)}g",
            iconColor: const Color.fromARGB(255, 221, 105, 105),
            iconData: Icons.set_meal_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MacroTile(
            label: "Carbs",
            value:
            "${_calculateNutrientValue(_foodItem!.carbsG).toStringAsFixed(1)}g",
            iconColor: const Color.fromARGB(255, 222, 154, 105),
            iconData: Icons.bubble_chart,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MacroTile(
            label: "Fats",
            value:
            "${_calculateNutrientValue(_foodItem!.fatG).toStringAsFixed(1)}g",
            iconColor: const Color.fromARGB(255, 105, 152, 222),
            iconData: Icons.oil_barrel,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedNutritionList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          for (final nutrient in _foodItem!.otherNutrients)
            if (nutrient.amount > 0)
              _NutritionRow(
                name: nutrient.name,
                value:
                "${_calculateNutrientValue(nutrient.amount).toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '')}${nutrient.unit}",
              ),
        ],
      ),
    );
  }

  Widget _buildLogButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          onPressed: _onLogFood,
          child: const Text(
            "Log",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
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

class _MeasurementTabs extends StatelessWidget {
  final PortionType selected;
  final ValueChanged<PortionType> onChanged;

  const _MeasurementTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabButton(
          label: "Tbsp",
          isActive: selected == PortionType.tbsp,
          onTap: () => onChanged(PortionType.tbsp),
        ),
        const SizedBox(width: 10),
        _TabButton(
          label: "G",
          isActive: selected == PortionType.grams,
          onTap: () => onChanged(PortionType.grams),
        ),
        const SizedBox(width: 10),
        _TabButton(
          label: "Serving",
          isActive: selected == PortionType.serving,
          onTap: () => onChanged(PortionType.serving),
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
    // Only update text if the value changed externally (e.g. from switching tabs)
    if (oldWidget.value != widget.value ||
        oldWidget.isGrams != widget.isGrams) {
      // Check if text is currently different to avoid overriding user typing
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

    final newValue = widget.isGrams
        ? parsed.roundToDouble().clamp(1, 9999)
        : parsed.clamp(0.1, 999);

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
              keyboardType: TextInputType.numberWithOptions(
                decimal: !widget.isGrams,
                signed: false,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              onSubmitted: _onCommit,
              onChanged: (v) {
                // Live updates for responsive UI
                final parsed = double.tryParse(v);
                if (parsed != null) {
                  // We don't clamp aggressively here to allow typing
                  widget.onChanged(parsed);
                }
              },
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Future.delayed(const Duration(milliseconds: 50), () {
                if (context.mounted) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              });
            },
            child: Icon(Icons.edit, size: 14, color: theme.hintColor),
          ),
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

  const _MacroTile({
    required this.label,
    required this.value,
    required this.iconData,
    required this.iconColor,
  });

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
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(5.0),
                child: Icon(iconData, size: 18, color: iconColor),
              ),
              const SizedBox(width: 5),
              Text(label,
                  style: TextStyle(color: theme.hintColor, fontSize: 12)),
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