import 'package:flutter/material.dart';

class ChecklistCard extends StatelessWidget {
  final bool calories;
  final bool carbs;
  final bool protein;
  final bool fats;
  final bool health;

  const ChecklistCard({
    super.key,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(-1, 0.5),
            blurRadius: 2.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily recommendation for",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          _item("Calories", calories, context),
          _item("Carbs", carbs, context),
          _item("Protein", protein, context),
          _item("Fats", fats, context),
          _item("Health score", health, context),
        ],
      ),
    );
  }

  Widget _item(String label, bool checked, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: checked ? 1 : 0,
            child: Icon(
              Icons.check_circle,
              size: 22,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
