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
            const CustomAppBar(title: Text("BMI")),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- BMI Card ---
                    const ProgressBmiCard(
                      decoration: BoxDecoration(color: Colors.transparent),
                      hasPadding: false,
                    ),
                    const SizedBox(height: 36),

                    // --- How it's Calculated ---
                    _buildSectionHeader("Disclaimer"),
                    const SizedBox(height: 8),
                    Text(
                      "As with most measures of health, BMI is not a perfect test. For example, results can be thrown off by pregnancy or high muscle mass, and it may not be a good measure of health for child or the elderly.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "So then, why does BMI matter?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '''In general, the higher your BMI, the higher the risk of developing a range of conditions linked with excess weight, including:
• diabetes
• arthritis
• liver disease
• several types of cancer (such as those of the breast, colon, and prostate)
• high blood pressure (hypertension)
• high cholesterol
• sleep apnea''', // <--- Make sure there are no spaces before the bullets
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.8),
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

  Widget _buildFormulaCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: const Center(
        child: Text(
          r"BMI = kg / m²",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildBmiCategoryTable() {
    final categories = [
      {
        'label': 'Underweight',
        'range': '< 18.5',
        'color': Colors.lightBlueAccent,
      },
      {'label': 'Healthy', 'range': '18.5 – 24.9', 'color': Colors.greenAccent},
      {
        'label': 'Overweight',
        'range': '25.0 – 29.9',
        'color': Colors.orangeAccent,
      },
      {'label': 'Obesity', 'range': '≥ 30.0', 'color': Colors.redAccent},
    ];

    return Column(
      children: categories
          .map(
            (cat) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        color: cat['color'] as Color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat['label'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    cat['range'] as String,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
