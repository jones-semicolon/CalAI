import 'package:calai/pages/home/home_page.dart';
import 'package:calai/pages/progress/progress_page.dart';
import 'package:calai/widgets/CustomFab.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar_widget.dart';
import '../data/notifiers.dart';
import '../pages/home/day_streak.dart';
import '../pages/home/float_action.dart';
import 'package:calai/pages/settings/settings_page.dart';
// import '../pages/home/day_item.dart';

List<Widget> pages = [HomeBody(), ProgressPage(), SettingsPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {

    const double FABSize = 65;

    return Scaffold(
      bottomNavigationBar: NavBarWidget(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: selectedPage,
                    builder: (context, pages, child) {
                      if (pages == 0) {
                        // Page 0: show logo + text
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/favicon.png', height: 32),
                            const Text(
                              'Cal AI',
                              style: TextStyle(
                                height: 1.5, //SETTING THIS CAN SOLVE YOUR PROBLEM
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      } else if (pages == 1) {
                        return const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                ]
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
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.local_fire_department, color: Colors.orange),
                              SizedBox(width: 6),
                              Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]
                          )
                        )
                      );
                    }
                )
              ]
            )
          ],
        )
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (context, page, child) {
          return pages.elementAt(page);
        },
      ),

      floatingActionButton: SizedBox(
        height: FABSize,
        width: FABSize,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: "",
              barrierColor: Colors.black26,
              transitionDuration: const Duration(milliseconds: 200),

              pageBuilder: (_, __, ___) {
                return const SizedBox.shrink();
              },

              transitionBuilder: (_, animation, __, ___) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    50 * (1 - animation.value),
                  ), // bottom to top animation
                  child: Opacity(
                    opacity: animation.value,
                    child: const FloatActionContent(),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: const LowerEndFloatFABLocation(30, -17),
    );
  }
}
