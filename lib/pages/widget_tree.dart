import 'package:calai/pages/home/home_page.dart';
import 'package:calai/pages/progress/progress_page.dart';
import 'package:calai/widgets/CustomFab.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar_widget.dart';
import '../data/notifiers.dart';
import '../pages/home/day_streak.dart';
import '../pages/home/float_action.dart';
import 'package:calai/pages/settings/settings_page.dart';

List<Widget> pages = [HomeBody(), ProgressPage(), SettingsPage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final double FABSize = 65;

  final ScrollController _scrollController = ScrollController();
  double _appBarHeight = 80; // initial AppBar height
  final double _minAppBarHeight = 0; // minimum height when fully scrolled

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      setState(() {
        _appBarHeight = (80 - offset).clamp(_minAppBarHeight, 80);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBarWidget(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: _appBarHeight,
          child: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
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
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/favicon.png',
                                height: 32,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              Text(
                                'Cal AI',
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        } else if (pages == 1) {
                          return Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          );
                        } else {
                          return Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          );
                        }
                      },
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
                              horizontal: 12,
                              vertical: 6,
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
                                    fontSize: 14,
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
            ),
          ),
        ),
      ),

      body: ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (context, page, child) {
          return SingleChildScrollView(
            controller:
                _scrollController, // scroll controller for shrinking app bar
            child: pages.elementAt(page),
          );
        },
      ),

      floatingActionButton: SizedBox(
        height: FABSize,
        width: FABSize,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.add,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
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
