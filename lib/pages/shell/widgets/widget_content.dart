import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Added
import 'package:calai/pages/shell/widgets/widget_pages.dart';
// ✅ Import the provider we created for the AppBar
import '../../../providers/navigation_provider.dart';
import 'animated_page_switcher.dart';

/// A widget that provides the main content for the `WidgetTree`.
class WidgetTreeContent extends ConsumerWidget { // ✅ Changed to ConsumerWidget
  const WidgetTreeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch the Riverpod provider instead of ValueListenable
    final pageIndex = ref.watch(selectedPageProvider);

    return AnimatedPageSwitcher(
      currentIndex: pageIndex,
      pages: widgetPages,
    );
  }
}