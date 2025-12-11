import 'package:flutter/material.dart';

class ShrinkableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget child;
  final double expandedHeight;
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

  void _onScroll() {
    double newOffset = widget.scrollController.offset;
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
    double height = widget.expandedHeight - offset;
    height = height.clamp(kToolbarHeight, widget.expandedHeight);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: widget.child,
    );
  }
}
