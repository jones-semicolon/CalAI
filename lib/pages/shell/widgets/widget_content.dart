import 'package:calai/pages/shell/widgets/widget_pages.dart';
import 'package:flutter/material.dart';

import '../../../data/notifiers.dart';
import 'animated_page_switcher.dart';

/// A widget that provides the main content for the `WidgetTree`.
///
/// It listens to page changes and uses [AnimatedPageSwitcher] to display the
/// currently selected page with a horizontal slide animation.
class WidgetTreeContent extends StatelessWidget {
  const WidgetTreeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder ensures that only this part of the widget tree
    // rebuilds when the selected page changes.
    return ValueListenableBuilder<int>(
      valueListenable: selectedPage,
      builder: (context, pageIndex, _) {
        return AnimatedPageSwitcher(
          currentIndex: pageIndex,
          pages: widgetPages,
        );
      },
    );
  }
}
