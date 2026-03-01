import 'package:calai/l10n/l10n.dart';
import 'package:calai/pages/progress/widgets/progress_bmi_card.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BmiInfoView extends ConsumerStatefulWidget {
  const BmiInfoView({super.key});

  @override
  ConsumerState<BmiInfoView> createState() => _BMIInfoViewState();
}

class _BMIInfoViewState extends ConsumerState<BmiInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: Text(context.l10n.yourBmiTitle)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProgressBmiCard(
                      decoration: BoxDecoration(color: Colors.transparent),
                      hasPadding: false,
                    ),
                    const SizedBox(height: 36),
                    _buildSectionHeader(context.l10n.bmiDisclaimerTitle),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.bmiDisclaimerBody,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.bmiWhyItMattersTitle,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.bmiWhyItMattersBody,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
