import 'package:flutter/material.dart';
import '../../data/notifiers.dart';
import 'widgets/show_action_grid_dialog.dart'; // The new, clean dialog function

/// The main Floating Action Button for the application's widget tree.
///
/// It listens to the selected page and, when pressed, triggers a custom dialog
/// to show more actions.
class WidgetTreeFAB extends StatelessWidget {
  const WidgetTreeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPage,
      builder: (context, page, _) {
        return SizedBox(
          height: 65,
          width: 65,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            // The onPressed callback is now a simple, clean function call.
            onPressed: () => showActionGridDialog(context),
            child: Icon(
              Icons.add,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        );
      },
    );
  }
}
