import 'package:flutter/material.dart';

class iosDiv extends StatelessWidget {
  const iosDiv({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1.5,
      color: Theme.of(context).splashColor,
    );
  }
}
