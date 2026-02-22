import 'package:flutter/material.dart';

/// A widget that switches between pages with a horizontal slide animation.
///
/// This widget manages the animation controllers and transition logic, providing
/// a clean and reusable way to animate page changes.
class AnimatedPageSwitcher extends StatefulWidget {
  final int currentIndex;
  final List<Widget> pages;
  final Duration duration;

  const AnimatedPageSwitcher({
    super.key,
    required this.currentIndex,
    required this.pages,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedPageSwitcher> createState() => _AnimatedPageSwitcherState();
}

class _AnimatedPageSwitcherState extends State<AnimatedPageSwitcher>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // State to track the page being displayed and the one transitioning out.
  int _displayIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayIndex = widget.currentIndex;
    _previousIndex = widget.currentIndex;

    _controller = AnimationController(vsync: this, duration: widget.duration);

    // After the animation completes, we only need the current page,
    // so we update the state to remove the old one.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _previousIndex = _displayIndex;
          _controller.reset();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedPageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      // When the index changes, update the state and trigger the animation.
      setState(() {
        _previousIndex = oldWidget.currentIndex;
        _displayIndex = widget.currentIndex;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If the controller isn't animating, just show the current page.
    if (!_controller.isAnimating) {
      return widget.pages[_displayIndex];
    }

    final bool isForward = _displayIndex > _previousIndex;
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    // Use a Stack to layer the incoming and outgoing pages during the transition.
    return Stack(
      children: [
        // Outgoing page
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: Offset(isForward ? -1.0 : 1.0, 0.0),
          ).animate(curve),
          child: widget.pages[_previousIndex],
        ),

        // Incoming page
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset(isForward ? 1.0 : -1.0, 0.0),
            end: Offset.zero,
          ).animate(curve),
          child: widget.pages[_displayIndex],
        ),
      ],
    );
  }
}
