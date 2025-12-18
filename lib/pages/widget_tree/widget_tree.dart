import 'package:flutter/material.dart';
import '../../widgets/lower_end_fab_location.dart';
import '../../widgets/navbar_widget.dart';
import '../../widgets/radial_background/radial_background.dart';

import 'widget_app_bar.dart';
import 'widget_content.dart';
import 'widget_fab.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const NavBarWidget(),
        appBar: const WidgetTreeAppBar(),
        body: const WidgetTreeContent(),
        floatingActionButton: const WidgetTreeFAB(),
        floatingActionButtonLocation:
        const LowerEndFloatFABLocation(30, -17),
      ),
    );
  }
}
