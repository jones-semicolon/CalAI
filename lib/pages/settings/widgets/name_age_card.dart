import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/core/constants/constants.dart';
import 'package:calai/data/user_data.dart'; // Ensure this points to your userProvider
import '../edit_name.dart';

class NameAgeCard extends ConsumerWidget {
  const NameAgeCard({super.key});

  /// Helper to calculate age from DateTime
  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 1. Watch the userProvider to get the current name and birthday
    final user = ref.watch(userProvider);
    final String name = user.name;
    final int age = _calculateAge(user.birthDay);
    final bool isNameEmpty = name.trim().isEmpty;

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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color.fromARGB(26, 185, 168, 209),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outlined, size: 30),
          ),
          const SizedBox(width: 16),
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
                  // 2. No longer need ValueListenableBuilder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        isNameEmpty ? "Enter your name" : name,
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (isNameEmpty)
                        const Icon(Icons.edit, size: 18, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // 3. Display the calculated age
                  Text(
                    "$age years old",
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}