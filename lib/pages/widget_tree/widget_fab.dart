import 'package:flutter/material.dart';
import '../../data/notifiers.dart';
import '../../pages/home/float_action.dart';

class WidgetTreeFAB extends StatelessWidget {
  const WidgetTreeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
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
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: '',
                barrierColor: Colors.black26,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, anim1, anim2) {
                  // You can return an empty container, the transitionBuilder will render the dialog
                  return const SizedBox.shrink();
                },
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final curvedAnim = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      );

                      return Opacity(
                        opacity: curvedAnim.value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - curvedAnim.value)),
                          child: const FloatingActionGrid(),
                        ),
                      );
                    },
              );
            },
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
