import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Update these paths to match your project structure
import 'package:calai/api/food_api.dart';
import 'package:calai/models/food_model.dart';
import '../../../../enums/food_enums.dart';
import '../../../../providers/global_provider.dart';
import '../../../../widgets/circle_back_button.dart';
import '../../../../widgets/header_widget.dart';
import 'selected_food_page.dart';
import '../../../../providers/entry_streams_provider.dart'; // Ensure correct path
import '../../../../services/calai_firestore_service.dart'; // Ensure correct path

class FoodDatabasePage extends ConsumerStatefulWidget {
  final int selectedTabIndex;
  const FoodDatabasePage({super.key, this.selectedTabIndex = 0});

  @override
  ConsumerState<FoodDatabasePage> createState() => _FoodDatabasePageState();
}

class _FoodDatabasePageState extends ConsumerState<FoodDatabasePage> {
  // State
  final TextEditingController _searchController = TextEditingController();
  late int _selectedTabIndex = widget.selectedTabIndex;
  bool _isLoadingSuggestions = true;
  bool _isSearching = false;
  List<Food> _suggestedFoods = [];
  List<Food> _searchResults = [];

  Timer? _debounce;

  // Constants
  static const List<String> _tabs = [
    "All",
    "My meals",
    "My foods",
    "Saved scans",
  ];

  // IDs are Strings in your new model
  static const List<String> _featuredFoodIds = [
    "2707537", // Peanut butter
    "2709223", // Avocado
    "2707152", // Egg
    "2709215", // Apples
    "2709614", // Spinach
  ];

  @override
  void initState() {
    super.initState();
    _fetchFeaturedSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ===========================================================================
  // Logic & API
  // ===========================================================================

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isSearching = true);

      try {
        final results = await FoodApi.search(query);

        if (mounted) {
          setState(() {
            _searchResults = results;
            _isSearching = false;
          });
        }
      } catch (e) {
        debugPrint("Search error: $e");
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

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

  FoodPortionItem _getDisplayPortion(Food item) {
    // ✅ FIX: Don't call .fromJson() here.
    // The model already parsed it. Just cast the list to the correct type.
    final List<FoodPortionItem> portions = item.portions.cast<FoodPortionItem>();

    if (portions.isEmpty) {
      return const FoodPortionItem(label: "Serving", gramWeight: 100);
    }

    // Try to find a portion that isn't just "100g" or "Quantity not specified"
    return portions.firstWhere(
          (p) => !p.label.toLowerCase().contains("quantity not specified"),
      orElse: () => portions.first,
    );
  }

  void _onAddFood(Food item, FoodPortionItem portion) async {
    // 1. Get the date the user is currently viewing on the dashboard
    final activeDateId = ref.read(globalDataProvider).value?.activeDateId;

    // 2. Create the log entry using your model's logic
    final logEntry = item.createLog(
      amount: 1.0,
      unit: portion.label,
      gramWeight: portion.gramWeight,
    );

    try {
      // 3. Use the Service (Source of Truth for DB Writes)
      await ref.read(calaiServiceProvider).logFoodEntry(
        logEntry,
        SourceType.foodDatabase,
        dateId: activeDateId, // ✅ Pass the viewed date
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added ${item.name} to $activeDateId"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error adding food: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add food. Try again.")),
        );
      }
    }
  }

  void _onLogEmptyFood() {
    debugPrint("Log empty food tapped");
    // TODO: Navigate to empty food log form
  }

  void _navigateToFoodDetails(Food item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SelectedFoodPage(foodId: item.id)),
    );
  }

  // ===========================================================================
  // UI Building
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isShowingSearchResults = _searchController.text.isNotEmpty;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: const Text("Food Database"),
              onBackTap: () => Navigator.pop(context),
            ),
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
                  // Only show "Suggestions" title if not searching
                  _selectedTabIndex == 0
                      ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isShowingSearchResults ? "Search Results" : "Suggestions",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            _buildContentList(theme, isShowingSearchResults),
          ],
        ),
      ),
    );
  }

  Widget _buildContentList(ThemeData theme, bool isShowingSearchResults) {
    if (_selectedTabIndex == 3) {
      return _buildSavedScansList(theme);
    }

    // 👉 Handle Search State
    if (isShowingSearchResults) {
      if (_isSearching) {
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      }
      if (_searchResults.isEmpty) {
        return const Expanded(child: Center(child: Text("No items found.")));
      }
      return _buildFoodList(_searchResults, theme);
    }

    // 👉 Default: API suggestions
    return _buildSuggestionsList(theme);
  }

  // ✅ Helper to keep code clean since Search and Suggestions look the same
  Widget _buildFoodList(List<Food> items, ThemeData theme) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];

          // Use helper to get the "best" portion to display
          final portion = _getDisplayPortion(item);

          // Calculate preview calories for 1 unit of this portion
          final previewLog = item.createLog(
              amount: 1,
              unit: portion.unitOnly,
              gramWeight: portion.gramWeight
          );

          // debugPrint(previewLog.calories.toString());

          return FoodTile(
            name: item.name,
            calories: previewLog.calories,
            unit: portion.unitOnly, // Use the getter from your FoodPortionItem
            onAdd: () => _onAddFood(item, portion),
            onTap: () => _navigateToFoodDetails(item),
          );
        },
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

    // Reuse the generic builder
    return _buildFoodList(_suggestedFoods, theme);
  }

  Widget _buildSavedScansList(ThemeData theme) {
    // 1. Watch the stream provider
    final savedFoodsAsync = ref.watch(savedFoodsStreamProvider);

    // 2. Loading State
    if (savedFoodsAsync.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    // 3. Error State
    if (savedFoodsAsync.hasError) {
      return Expanded(
        child: Center(child: Text("Error: ${savedFoodsAsync.error}")),
      );
    }

    // 4. Extract data safely
    final foods = savedFoodsAsync.value ?? [];

    // 5. Empty State
    if (foods.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("No saved scans yet", style: TextStyle(fontSize: 16)),
        ),
      );
    }

    // 6. Success: Reuse generic builder
    return _buildFoodList(foods, theme);
  }

  // ... (Header, SearchBox, Tabs, Reusable Widgets remain identical) ...

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleBackButton(onTap: () => Navigator.pop(context)),
          const SizedBox(width: 12),
          const Expanded(
            child: Center(
              child: Text(
                "Food Database",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildSearchBox(ThemeData theme) {
    return _SearchInput(
      controller: _searchController,
      hint: "Describe what you ate",
      onChanged: _onSearchChanged,
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index == _tabs.length - 1 ? 0 : 22),
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
}

// ===========================================================================
// Reusable Widgets
// ===========================================================================

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
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.onTertiary.withOpacity(0.45),
          borderRadius: BorderRadius.circular(18),
        ),
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
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, size: 20),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "$calories cal  ·  ${unit ?? 'Serving'}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
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