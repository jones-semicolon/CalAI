import 'package:calai/pages/auth/auth.dart';
import 'package:calai/pages/shell/widgets/widget_app_bar.dart';
import 'package:calai/pages/shell/widgets/widget_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/global_data.dart';

// Global App Widgets
import '../../widgets/lower_end_fab_location.dart';
import '../../widgets/navbar_widget.dart';
import '../../widgets/radial_background/radial_background.dart';

// Page-Specific Widgets
import 'widgets/widget_fab.dart';

class WidgetTree extends ConsumerStatefulWidget {
  const WidgetTree({super.key});

  @override
  ConsumerState<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends ConsumerState<WidgetTree> {
  bool _booted = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (_booted) return;
      _booted = true;

      // ✅ If no logged in user → fallback to guest
      if (AuthService.getCurrentUser() == null) {
        await AuthService.signInAsGuest();
      }

      // ✅ Now you always have a UID here
      await ref.read(globalDataProvider.notifier).init();
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
            WidgetTreeAppBar(),
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
