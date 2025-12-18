import 'package:flutter/material.dart';

/// A custom AppBar that shrinks when the user scrolls down.
///
/// It listens to the provided [ScrollController] and adjusts its height
/// between [expandedHeight] and the minimum toolbar height.
class ShrinkableAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// The content inside the AppBar.
  final Widget child;

  /// The height of the AppBar when fully expanded.
  final double expandedHeight;

  /// The ScrollController used to detect scrolling.
  final ScrollController scrollController;

  const ShrinkableAppBar({
    super.key,
    required this.child,
    required this.scrollController,
    this.expandedHeight = 80,
  });

  @override
  _ShrinkableAppBarState createState() => _ShrinkableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight);
}

class _ShrinkableAppBarState extends State<ShrinkableAppBar> {
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  /// Updates the offset based on scroll position and triggers rebuild.
  void _onScroll() {
    final newOffset = widget.scrollController.offset;
    if (newOffset != offset) {
      setState(() {
        offset = newOffset.clamp(0.0, widget.expandedHeight);
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the current height of the AppBar.
    double height = (widget.expandedHeight - offset).clamp(
      kToolbarHeight,
      widget.expandedHeight,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: widget.child,
    );
  }
}
