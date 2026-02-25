import 'package:calai/pages/auth/auth.dart';
import 'package:calai/pages/shell/widgets/widget_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/global_provider.dart';
import '../../widgets/lower_end_fab_location.dart';
import '../../widgets/navbar_widget.dart';
import '../../widgets/radial_background/radial_background.dart';

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

      if (AuthService.getCurrentUser() == null) {
        debugPrint("👤 No user found, signing in as guest...");
        await AuthService.signInAsGuest();
        await Future.delayed(Duration.zero);
      }

      final notifier = ref.read(globalDataProvider.notifier);
      await notifier.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const RadialBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: NavBarWidget(),
        body: WidgetTreeContent(),
        floatingActionButton: WidgetTreeFAB(),
        floatingActionButtonLocation: LowerEndFloatFABLocation(30, -17),
      ),
    );
  }
}
