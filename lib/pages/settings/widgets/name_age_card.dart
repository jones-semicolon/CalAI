import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import 'package:calai/data/notifiers.dart';
import '../edit_name.dart';

/// A card widget to display the user's name and age, with a button to
/// navigate to the name editing page.
///
/// It listens to a [ValueNotifier] to reactively update the displayed name.
class NameAgeCard extends StatelessWidget {
  const NameAgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: theme.splashColor.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // The user avatar icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color.fromARGB(26, 185, 168, 209),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outlined, size: 30),
          ),
          const SizedBox(width: 16),
          // The tappable section for name and age
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditNamePage()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: changeName,
                    builder: (context, name, _) {
                      final bool isNameEmpty = name.isEmpty;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            isNameEmpty ? "Enter your name" : name,
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          const SizedBox(width: 5),
                          if (isNameEmpty)
                            const Icon(Icons.edit,
                                size: 18, color: Colors.grey),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text("17 years old",
                      style: TextStyle(color: colorScheme.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
