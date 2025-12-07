import 'package:flutter/material.dart';
import 'home_body.dart';
import 'day_streak.dart';
import 'float_action.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeBody(),
    Center(child: Text("Progress Page")),
    Center(child: Text("Settings Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedIndex == 0
                  ? "Cal AI"
                  : selectedIndex == 1
                  ? "Progress"
                  : "Settings",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            /// Show DayStreak ONLY on Home tab
            selectedIndex == 0
                ? GestureDetector(
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),

      body: pages[selectedIndex],

      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (i) => setState(() => selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            label: "Progress",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
