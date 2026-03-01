import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  final VoidCallback onFinished;

  const SubscriptionPage({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    const yearlyPrice = 1750.00;
    final monthlyPrice = yearlyPrice / 12;
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onTertiaryFixed,
                  ),
                  onPressed: onFinished,
                ),
              ),
              Text(
                l10n.subscriptionHeadline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onFinished,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    l10n.continueLabel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                l10n.subscriptionPriceHint(
                  yearlyPrice.toStringAsFixed(2),
                  monthlyPrice.toStringAsFixed(2),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: scheme.onTertiaryFixed,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
