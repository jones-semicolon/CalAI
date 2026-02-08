import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Added
import '../../../providers/navigation_provider.dart'; // ✅ Import your new provider
import 'show_action_grid_dialog.dart';

/// The main Floating Action Button for the application's widget tree.
class WidgetTreeFAB extends ConsumerWidget { // ✅ Changed to ConsumerWidget
  const WidgetTreeFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch the Riverpod provider
    final page = ref.watch(selectedPageProvider);

    // You can now use 'page' to hide the FAB on specific screens
    if (page == 3) { // Assuming index 3 is Settings
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 65,
      width: 65,
      child: FloatingActionButton(
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => showActionGridDialog(context),
        child: Icon(
          Icons.add,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}