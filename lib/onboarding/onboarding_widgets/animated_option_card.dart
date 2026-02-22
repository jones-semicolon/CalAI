import 'package:flutter/material.dart';

class AnimatedOptionCard extends StatefulWidget {
  final Widget child;
  final int index; // for cascading effect
  final Duration duration;

  const AnimatedOptionCard({
    super.key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  State<AnimatedOptionCard> createState() => _AnimatedOptionCardState();
}

class _AnimatedOptionCardState extends State<AnimatedOptionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // starting scale decreases with index for cascading
    double startScale = 1.0 - (widget.index * 0.1);
    if (startScale < 0.5) startScale = 0.5;

    _scaleAnimation = Tween<double>(
      begin: startScale,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start animation after a tiny delay per index to see cascading better
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(opacity: _opacityAnimation, child: widget.child),
    );
  }
}
