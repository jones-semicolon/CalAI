import 'package:flutter/material.dart';
import '../../data/notifiers.dart';
import '../home/day_streak.dart';

class WidgetTreeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WidgetTreeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (context, page, _) {
          switch (page) {
            case 0:
              return _homeTitle(context);
            case 1:
              return _title(context, 'Progress');
            default:
              return _title(context, 'Settings');
          }
        },
      ),
    );
  }

  Widget _homeTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/favicon.png',
              height: 32,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              'Cal AI',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            ValueListenableBuilder(
              valueListenable: selectedPage,
              builder: (context, page, child) {
                if (page != 0) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.black26,
                      builder: (_) => const DayStreakDialog(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _title(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
