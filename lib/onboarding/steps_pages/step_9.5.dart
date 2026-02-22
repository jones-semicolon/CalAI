import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/header.dart';

class Demotivated extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const Demotivated({super.key, required this.nextPage});

  @override
  ConsumerState<Demotivated> createState() => _DemotivatedState();
}

class _DemotivatedState extends ConsumerState<Demotivated> {
  // Track the enum type instead of an index
  ObstacleType? selectedObstacle;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    // Sync initial state from provider if available
    final currentStrategy = user.goal.maintenanceStrategy;
    if (selectedObstacle == null && currentStrategy != null) {
      // Try to find the enum matching the saved string
      try {
        selectedObstacle = ObstacleType.values.firstWhere(
                (e) => e.title == currentStrategy
        );
      } catch (_) {
        // Handle case where string doesn't match any enum
      }
    }

    return SafeArea(
      child: Column(
        children: [
          const Header(title: "What's stopping you from reaching your goals?"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: ObstacleType.values.map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: AnimatedOptionCard(
                      index: type.index, // Using enum's built-in index for animation
                      child: OptionCard(
                        icon: type.icon,
                        title: type.title,
                        isSelected: selectedObstacle == type,
                        onTap: () => setState(() => selectedObstacle = type),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          ConfirmationButtonWidget(
            enabled: selectedObstacle != null,
            onConfirm: () {
              if (selectedObstacle != null) {
                userNotifier.updateLocal((s) => s.copyWith(
                  goal: s.goal.copyWith(maintenanceStrategy: ObstacleType.fromString(selectedObstacle!.title)),
                ));
              }
              widget.nextPage();
            },
          )
        ],
      ),
    );
  }
}