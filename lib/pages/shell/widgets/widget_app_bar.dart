import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add this
import 'package:calai/widgets/radial_background/radial_background.dart';
import 'package:calai/l10n/l10n.dart';
// Import your navigation provider
import '../../../providers/navigation_provider.dart';
import 'app_title.dart';
import 'generic_app_bar_title.dart';
import 'streak_indicator_button.dart';

class WidgetTreeAppBar extends ConsumerWidget { // Changed to ConsumerWidget
  const WidgetTreeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current page index from Riverpod
    final pageIndex = ref.watch(selectedPageProvider);

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final bool isScrolled = constraints.scrollOffset > 0;

        return SliverAppBar(
          pinned: false,
          floating: true,
          snap: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: isScrolled
              ? ClipRect(
            child: RadialBackground(
              child: Container(color: Colors.transparent),
            ),
          )
              : null,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,

          // Simplified: No more ValueListenableBuilder
          title: _getAppBarTitle(context, pageIndex),
        );
      },
    );
  }

  Widget _getAppBarTitle(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const _HomeAppBarTitle();
      case 1:
        return GenericAppBarTitle(title: context.l10n.progressTab);
      case 2:
        return GenericAppBarTitle(title: context.l10n.settingsTab);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _HomeAppBarTitle extends StatelessWidget {
  const _HomeAppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppTitle(),
        StreakIndicatorButton(),
      ],
    );
  }
}
