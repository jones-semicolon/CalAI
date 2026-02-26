import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:calai/api/food_api.dart';
import 'package:calai/models/food_model.dart';
import 'package:calai/pages/home/recently_logged/logged_view/logged_food_view.dart';
import '../../../../enums/food_enums.dart';
import '../../../../providers/global_provider.dart';
import '../../../../widgets/header_widget.dart';
import 'selected_food_page.dart';
import '../../../../providers/entry_streams_provider.dart';
import '../../../../services/calai_firestore_service.dart';

class FoodDatabasePage extends ConsumerStatefulWidget {
  final int selectedTabIndex;
  const FoodDatabasePage({super.key, this.selectedTabIndex = 0});

  @override
  ConsumerState<FoodDatabasePage> createState() => _FoodDatabasePageState();
}

class _FoodDatabasePageState extends ConsumerState<FoodDatabasePage> {
  final TextEditingController _searchController = TextEditingController();
  late int _selectedTabIndex = widget.selectedTabIndex;

  bool _isLoadingSuggestions = true;
  bool _isSearching = false;
  List<Food> _suggestedFoods = [];
  List<Food> _searchResults = [];

  Timer? _debounce;

  static const List<String> _tabs = ["All", "My meals", "My foods", "Saved scans"];
  static const List<String> _featuredFoodIds = ["2707537", "2709223", "2707152", "2709215", "2709614"];

  @override
  void initState() {
    super.initState();
    // Cache suggestions early
    _fetchFeaturedSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ===========================================================================
  // Logic & Performance
  // ===========================================================================

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.isEmpty) {
      setState(() { _searchResults = []; _isSearching = false; });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      setState(() => _isSearching = true);
      try {
        final results = await FoodApi.search(query);
        if (mounted) setState(() { _searchResults = results; });
      } finally {
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

  Future<void> _fetchFeaturedSuggestions() async {
    try {
      final foods = await FoodApi.getFoodsByIds(_featuredFoodIds);
      if (mounted) setState(() { _suggestedFoods = foods; _isLoadingSuggestions = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoadingSuggestions = false);
    }
  }

  void _onAddFood(Food item, FoodPortionItem portion) async {
    final activeDateId = ref.read(globalDataProvider).value?.activeDateId;
    final logEntry = item.createLog(amount: 1.0, unit: portion.label, gramWeight: portion.gramWeight);

    try {
      await ref.read(calaiServiceProvider).logFoodEntry(logEntry, SourceType.foodDatabase, dateId: activeDateId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added ${item.name}"), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1)),
        );
      }
    } catch (e) { debugPrint("Add Error: $e"); }
  }

  void _onUnsaveFood(Food item) async {
    final originalItems = _suggestedFoods;
    try {
      await ref.read(calaiServiceProvider).unsaveFood(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Removed ${item.name}"), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) { debugPrint("Delete Error: $e"); }
  }

  // ===========================================================================
  // UI Optimized Sections
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isSearching = _searchController.text.isNotEmpty;
    final String sectionTitle = _selectedTabIndex == 0 && !isSearching ? "Suggestions" : (isSearching && _selectedTabIndex != 3 ? "Search Results" : "");

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: Text("Food Database")),
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoggedFoodView())),
                  ),
                  const SizedBox(height: 18),
                  if (sectionTitle.isNotEmpty) ...[
                    Align(alignment: Alignment.centerLeft, child: Text(sectionTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            _buildContentList(theme, isSearching),
          ],
        ),
      ),
    );
  }

  Widget _buildContentList(ThemeData theme, bool isSearching) {
    if (isSearching && _selectedTabIndex == 0) {
      if (_isSearching) return const Expanded(child: Center(child: CupertinoActivityIndicator(radius: 15)));
      return _searchResults.isEmpty ? const Expanded(child: Center(child: Text("No items found."))) : _buildFoodList(_searchResults, theme, canDelete: false);
    }

    return switch (_selectedTabIndex) {
      1 => _buildFilteredStream(SourceType.foodUpload, "No meals saved"),
      2 => _buildFilteredStream(SourceType.foodDatabase, "No foods saved"),
      3 => _buildFilteredStream(SourceType.vision, "No scans saved"),
      _ => _buildSuggestionsList(theme),
    };
  }

  Widget _buildFilteredStream(SourceType source, String emptyMsg) {
    return ref.watch(savedFoodsStreamProvider).when(
      loading: () => const Expanded(child: Center(child: CupertinoActivityIndicator(radius: 15))),
      error: (err, _) => Expanded(child: Center(child: Text("Error loading data"))),
      data: (allFoods) {
        final filtered = allFoods.where((f) => SourceType.fromString(f.source) == source).toList();
        return filtered.isEmpty ? Expanded(child: Center(child: Text(emptyMsg))) : _buildFoodList(filtered, Theme.of(context), canDelete: true);
      },
    );
  }

  Widget _buildSuggestionsList(ThemeData theme) {
    if (_isLoadingSuggestions) return const Expanded(child: Center(child: CupertinoActivityIndicator(radius: 15)));
    return _buildFoodList(_suggestedFoods, theme, canDelete: false);
  }

  Widget _buildFoodList(List<Food> items, ThemeData theme, {required bool canDelete}) {
    return Expanded(
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            final portion = _getDisplayPortion(item);
        
            Widget tile = FoodTile(
              key: ValueKey('tile_${item.id}'),
              name: item.name,
              calories: item.calories,
              unit: portion.unitOnly,
              onAdd: () => _onAddFood(item, portion),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SelectedFoodPage(foodId: item.id, foodItem: item))),
            );
        
            if (!canDelete) return tile;
        
            return Slidable(
              key: ValueKey('slidable_${item.id}'),
              endActionPane: ActionPane(
                motion: const BehindMotion(),
                extentRatio: 0.25,
                dismissible: DismissiblePane(
                  onDismissed: () => _onUnsaveFood(item),
                ),
                children: [
                  SlidableAction(
                    onPressed: (_) => _onUnsaveFood(item),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: BorderRadius.circular(18),
                  ),
                ],
              ),
              child: tile,
            );
          },
        ),
      ),
    );
  }

  FoodPortionItem _getDisplayPortion(Food item) {
    if (item.portions.isEmpty) return const FoodPortionItem(label: "Serving", gramWeight: 100);
    return item.portions.cast<FoodPortionItem>().firstWhere(
          (p) => !p.label.toLowerCase().contains("quantity not specified"),
      orElse: () => item.portions.first as FoodPortionItem,
    );
  }

  Widget _buildSearchBox(ThemeData theme) => _SearchInput(controller: _searchController, hint: "Search foods...", onChanged: _onSearchChanged);

  Widget _buildTabs() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(_tabs.length, (index) => Padding(
        padding: EdgeInsets.only(right: index == _tabs.length - 1 ? 0 : 22),
        child: _TabItem(label: _tabs[index], isSelected: index == _selectedTabIndex, onTap: () => setState(() => _selectedTabIndex = index)),
      )),
    ),
  );
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
  final num calories;
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
                          "${calories.round()} cal  ·  ${unit ?? 'Serving'}",
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
