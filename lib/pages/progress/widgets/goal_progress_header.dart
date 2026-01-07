import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

class GoalProgressHeader extends StatelessWidget {
  final double progressPercent;
  final VoidCallback? onEdit;

  const GoalProgressHeader({
    super.key,
    required this.progressPercent,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            'Goal Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onTertiary,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme.secondary
                      .withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 5),
                  Text(
                    '${progressPercent.round()}%',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('of goal', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 5),
                  Icon(Icons.edit,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
