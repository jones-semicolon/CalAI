import 'package:flutter/material.dart';

// Global App Widgets
import '../../widgets/lower_end_fab_location.dart';
import '../../widgets/navbar_widget.dart';
import '../../widgets/radial_background/radial_background.dart';

// Page-Specific Widgets
import 'widget_app_bar.dart';
import 'widget_content.dart';
import 'widget_fab.dart';

/// The root widget that assembles the main UI structure of the application.
///
/// It combines the background, navigation bar, app bar, floating action button,
/// and the main page content into a single, cohesive layout.
class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return const RadialBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: NavBarWidget(),
        body: CustomScrollView(
          slivers: [
            // The app bar, which dynamically changes based on the selected page.
            WidgetTreeAppBar(),

            // The main content area, which uses its own listener to switch
            // between different pages with an animation.
            SliverToBoxAdapter(
              child: WidgetTreeContent(),
            ),
          ],
        ),
        floatingActionButton: WidgetTreeFAB(),
        floatingActionButtonLocation: LowerEndFloatFABLocation(30, -17),
      ),
    );
  }
}
