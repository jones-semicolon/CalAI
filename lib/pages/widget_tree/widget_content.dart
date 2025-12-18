import 'package:flutter/material.dart';
import '../../data/notifiers.dart';
import 'widget_pages.dart';

class WidgetTreeContent extends StatefulWidget {
  const WidgetTreeContent({super.key});

  @override
  State<WidgetTreeContent> createState() => _WidgetTreeContentState();
}

class _WidgetTreeContentState extends State<WidgetTreeContent> {
  int _previousPage = selectedPage.value;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPage,
      builder: (context, page, _) {
        final bool isForward = page > _previousPage;
        final int previousPage = _previousPage;
        _previousPage = page;

        return Stack(
          children: [
            // Outgoing page
            if (previousPage != page)
              SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(isForward ? -1.0 : 1.0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: AnimationController(
                      vsync: Scaffold.of(context),
                      duration: const Duration(milliseconds: 400),
                    )..forward(),
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: widgetPages[previousPage],
              ),

            // Incoming page
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(isForward ? 1.0 : -1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: AnimationController(
                    vsync: Scaffold.of(context),
                    duration: const Duration(milliseconds: 400),
                  )..forward(),
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: widgetPages[page],
            ),
          ],
        );
      },
    );
  }
}
