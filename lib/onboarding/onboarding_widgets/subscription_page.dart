import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  final VoidCallback onFinished;

  const SubscriptionPage({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    const yearlyPrice = 1750.00;
    final monthlyPrice = yearlyPrice / 12;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Close action
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

              // Headline
              Text(
                'Unlock CalAI to reach\nyour goals faster.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),

              const Spacer(),

              // Primary CTA
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
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Pricing hint
              Text(
                'Just ₱${yearlyPrice.toStringAsFixed(2)} per year '
                '(₱${monthlyPrice.toStringAsFixed(2)}/mo)',
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
