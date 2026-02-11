import 'package:flutter/material.dart';

class ScanCorner extends StatelessWidget {
  final BorderRadius radius;
  final bool top, right, bottom, left;

  const ScanCorner({
    super.key,
    required this.radius,
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.left = false,
  });

  @override
  Widget build(BuildContext context) {
    const border = BorderSide(color: Colors.white70, width: 4);

    return SizedBox(
      width: 40,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border(
            top: top ? border : BorderSide.none,
            right: right ? border : BorderSide.none,
            bottom: bottom ? border : BorderSide.none,
            left: left ? border : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
