import 'dart:ui';

import 'package:calai/widgets/radial_background/radial_background.dart';
import 'package:flutter/material.dart';
import '../../data/notifiers.dart';
import 'widgets/app_title.dart';
import 'widgets/generic_app_bar_title.dart';
import 'widgets/streak_indicator_button.dart';

/// A SliverAppBar that dynamically changes its title based on the selected page.
///
/// It listens to a [ValueNotifier] and switches between the main app title
/// (with a streak button) and generic titles for other pages.
class WidgetTreeAppBar extends StatelessWidget {
  const WidgetTreeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
            // The BackdropFilter applies a blur to everything behind it.
            child: RadialBackground(
              child: Container(
                color: Colors.transparent,
              ),
            ),
          )
              : null,

          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,

          centerTitle: false,

          title: ValueListenableBuilder<int>(
            valueListenable: selectedPage,
            builder: (context, page, _) {
              switch (page) {
                case 0:
                  return const _HomeAppBarTitle();
                case 1:
                  return const GenericAppBarTitle(title: 'Progress');
                default:
                  return const GenericAppBarTitle(title: 'Settings');
              }
            },
          ),
        );
      },
    );
  }
}

/// A private widget that defines the specific layout for the home page app bar title.
///
/// This includes the main app title and the streak indicator button.
class _HomeAppBarTitle extends StatelessWidget {
  const _HomeAppBarTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTitle(),
        StreakIndicatorButton(),
      ],
    );
  }
}
