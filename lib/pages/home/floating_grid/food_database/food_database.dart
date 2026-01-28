import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:calai/api/food_api.dart';
// Ensure this import path matches where your SelectedFoodPage is located
import '../../../../data/global_data.dart';
import 'selected_food_page.dart';

class FoodDatabasePage extends StatefulWidget {
  final int selectedTabIndex;
  const FoodDatabasePage({super.key, this.selectedTabIndex = 0
  });

  @override
  State<FoodDatabasePage> createState() => _FoodDatabasePageState();
}

class _FoodDatabasePageState extends State<FoodDatabasePage> {
  // State
  final TextEditingController _searchController = TextEditingController();
  late int _selectedTabIndex = widget.selectedTabIndex;
  bool _isLoadingSuggestions = true;
  List<FoodSearchItem> _suggestedFoods = [];

  // Constants
  static const List<String> _tabs = [
    "All",
    "My meals",
    "My foods",
    "Saved scans"
  ];
  static const List<int> _featuredFoodIds = [
    2707537, // Peanut butter
    2709223, // Avocado
    2707152, // Egg
    2709215, // Apples
    2709614, // Spinach
  ];

  @override
  void initState() {
    super.initState();
    _fetchFeaturedSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<Food>> _savedFoodsStream() {
    return FirebaseFirestore.instance
        .collection('savedFoods')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Food.fromDoc(doc)).toList(),
    );
  }

  // ===========================================================================
  // Logic & API
  // ===========================================================================

  Future<void> _fetchFeaturedSuggestions() async {
    setState(() => _isLoadingSuggestions = true);

    try {
      final foods = await FoodApi.getFoodsByIds(_featuredFoodIds);

      if (mounted) {
        setState(() {
          _suggestedFoods = foods;
          _isLoadingSuggestions = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading suggestions: $e");
      if (mounted) {
        setState(() => _isLoadingSuggestions = false);
      }
    }
  }

  void _onAddFood(FoodSearchItem item, int calories) {
    GlobalDataNotifier().logFoodEntry(
      id: item.fdcId.toString(),
      name: item.name,
      calories: calories,
      p: item.nutrients?['protein_g']['amount'].toInt() ?? 0,
      c: item.nutrients?['carbs_g']['amount'].toInt() ?? 0,
      f: item.nutrients?['fat_g']['amount'].toInt() ?? 0,
      serving: item.defaultPortion.gramWeight.toInt(),
      source: FoodSource.foodDatabase,
    );
  }

  void _onLogEmptyFood() {
    debugPrint("Log empty food tapped");
    // TODO: Navigate to empty food log form
  }

  void _navigateToFoodDetails(FoodSearchItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectedFoodPage(foodId: item.fdcId),
      ),
    );
  }

  // ===========================================================================
  // UI Building
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  _buildSearchBox(theme),
                  const SizedBox(height: 14),
                  _buildTabs(),
                  const SizedBox(height: 14),
                  _OutlinedPillButton(
                    icon: Icons.edit,
                    text: "Log empty food",
                    onTap: _onLogEmptyFood,
                  ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Suggestions",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            _buildContentList(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildContentList(ThemeData theme) {
    // 👉 Saved scans tab
    if (_selectedTabIndex == 3) {
      return _buildSavedScansList(theme);
    }

    // 👉 Default: API suggestions
    return _buildSuggestionsList(theme);
  }

  Widget _buildSavedScansList(ThemeData theme) {
    return Expanded(
      child: StreamBuilder<List<Food>>(
        stream: _savedFoodsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No saved scans yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final foods = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            physics: const BouncingScrollPhysics(),
            itemCount: foods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final food = foods[index];

              return FoodTile(
                name: food.name,
                calories: food.calories,
                onTap: () {
                  // Optional: open saved food details
                },
                onAdd: () {
                  GlobalDataNotifier().logFoodEntry(
                    id: food.id,
                    name: food.name,
                    calories: food.calories,
                    p: 0,
                    c: 0,
                    f: 0,
                    serving: 0,
                    source: FoodSource.foodDatabase,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _CircleBackButton(onTap: () => Navigator.pop(context)),
          const SizedBox(width: 12),
          const Expanded(
            child: Center(
              child: Text(
                "Food Database",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 44), // Balances the back button width
        ],
      ),
    );
  }

  Widget _buildSearchBox(ThemeData theme) {
    return _SearchInput(
      controller: _searchController,
      hint: "Describe what you ate",
      onChanged: (value) {
        // TODO: Implement search logic
      },
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return Padding(
            padding:
            EdgeInsets.only(right: index == _tabs.length - 1 ? 0 : 22),
            child: _TabItem(
              label: _tabs[index],
              isSelected: index == _selectedTabIndex,
              onTap: () => setState(() => _selectedTabIndex = index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSuggestionsList(ThemeData theme) {
    if (_isLoadingSuggestions) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (_suggestedFoods.isEmpty) {
      return const Expanded(
        child: Center(child: Text("No suggestions available")),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
        physics: const BouncingScrollPhysics(),
        itemCount: _suggestedFoods.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _suggestedFoods[index];
          final portion = item.defaultPortion;
          final calories =
          item.nutrientsForPortion(portion, item.caloriesPer100g).round();

          return FoodTile(
            name: item.name,
            calories: calories,
            unit: portion.unitOnly,
            onAdd: () => _onAddFood(item, calories),
            onTap: () => _navigateToFoodDetails(item),
          );
        },
      ),
    );
  }
}

// ===========================================================================
// Reusable Widgets
// ===========================================================================

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CircleBackButton({required this.onTap});

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
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  const _SearchInput({
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiary.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.hintColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
          color: isSelected ? Colors.black : Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _OutlinedPillButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _OutlinedPillButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodTile extends StatelessWidget {
  final String name;
  final int calories;
  final String? unit;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const FoodTile({
    super.key,
    required this.name,
    required this.calories,
    this.unit,
    required this.onAdd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiary.withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "$calories cal  ·  $unit",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onAdd,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.onTertiary.withOpacity(0.8),
                ),
                child: const Icon(Icons.add, size: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }
}