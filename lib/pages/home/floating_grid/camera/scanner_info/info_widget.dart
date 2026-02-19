import 'package:flutter/material.dart';

class BestScanningPracticesScreen extends StatelessWidget {
  const BestScanningPracticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: BestScanningPracticesWidget(
                      onClose: () => Navigator.pop(context),
                      onScanNow: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BestScanningPracticesWidget extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onScanNow;

  const BestScanningPracticesWidget({
    super.key,
    required this.onClose,
    required this.onScanNow,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        _HeaderRow(onClose: onClose, textColor: textColor),
        const SizedBox(height: 20),
        _TipsTitle(textColor: textColor),
        const SizedBox(height: 12),
        _TipItem('Keep the food inside the scan lines', color: textColor),
        _TipItem(
          'Hold your phone still so the image is not blurry',
          color: textColor,
        ),
        _TipItem("Don't take the picture at obscure angles", color: textColor),
        const Spacer(),
        _ScanNowButton(onScanNow: onScanNow),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final VoidCallback onClose;
  final Color textColor;

  const _HeaderRow({required this.onClose, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Best scanning practices',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: IconButton(
            onPressed: onClose,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
              foregroundColor: Theme.of(context).colorScheme.primary,
              iconSize: 28,
              shape: const CircleBorder(),
            ),
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}

class _TipsTitle extends StatelessWidget {
  final Color textColor;

  const _TipsTitle({required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'General tips:',
        style: TextStyle(fontSize: 20, color: textColor),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;
  final Color color;

  const _TipItem(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: TextStyle(fontSize: 16, color: color)),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 16, color: color)),
          ),
        ],
      ),
    );
  }
}

class _ScanNowButton extends StatelessWidget {
  final VoidCallback onScanNow;

  const _ScanNowButton({required this.onScanNow});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onScanNow,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Scan now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
