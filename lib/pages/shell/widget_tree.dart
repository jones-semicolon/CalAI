import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Providers
import '../../data/global_data.dart';

// Global App Widgets
import '../../widgets/lower_end_fab_location.dart';
import '../../widgets/navbar_widget.dart';
import '../../widgets/radial_background/radial_background.dart';

// Page-Specific Widgets
import 'widget_app_bar.dart';
import 'widget_content.dart';
import 'widget_fab.dart';

class WidgetTree extends ConsumerStatefulWidget {
  const WidgetTree({super.key});

  @override
  ConsumerState<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends ConsumerState<WidgetTree> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(globalDataProvider.notifier).init();
    });
  }

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

            // The main content area
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