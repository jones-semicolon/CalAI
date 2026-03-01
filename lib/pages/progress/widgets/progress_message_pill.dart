import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ProgressMessagePill extends StatelessWidget {
  final double progressPercent;

  const ProgressMessagePill({super.key, required this.progressPercent});

  String _getMessage(BuildContext context) {
    final l10n = context.l10n;
    final percent = progressPercent.round();
    if (percent <= 24) return l10n.progressMessageStart;
    if (percent <= 49) return l10n.progressMessageKeepPushing;
    if (percent <= 74) return l10n.progressMessagePayingOff;
    if (percent <= 99) return l10n.progressMessageFinalStretch;
    return l10n.progressMessageCongrats;
  }

  @override
  Widget build(BuildContext context) {
    final message = _getMessage(context);
    const textStyle = TextStyle(
      color: Color.fromARGB(255, 35, 138, 29),
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(26, 35, 138, 29),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(text: message, style: textStyle),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout(minWidth: 0, maxWidth: double.infinity);

          final isOverflowing = textPainter.size.width > constraints.maxWidth;

          return isOverflowing
              ? Marquee(
                  text: message,
                  style: textStyle,
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 20.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                )
              : Center(
                  child: Text(
                    message,
                    style: textStyle,
                    maxLines: 1,
                  ),
                );
        },
      ),
    );
  }
}
