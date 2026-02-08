import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// TODO integrate Firestore data weight_history collection
class WeightHistoryView extends ConsumerStatefulWidget {
  const WeightHistoryView({super.key});

  @override
  ConsumerState<WeightHistoryView> createState() => _WeightHistoryViewState();
}

class _WeightHistoryViewState extends ConsumerState<WeightHistoryView> {
  @override
  Widget build(BuildContext context) {
    // --- SAMPLE DATA ---
    // Using a list of Maps to simulate what might come from Firestore
    final List<Map<String, dynamic>> sampleEntries = [
      {"date": DateTime(2026, 2, 5), "weight": 70.0},
      {"date": DateTime(2026, 2, 3), "weight": 71.2},
      {"date": DateTime(2026, 1, 28), "weight": 72.5},
      {"date": DateTime(2026, 1, 15), "weight": 74.0},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: Text("Weight History")),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: sampleEntries.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = sampleEntries[index];

                  // ✅ Extract and cast values safely
                  final DateTime dateValue = entry['date'] as DateTime;
                  final double weightValue = (entry['weight'] as num).toDouble();

                  // ✅ Format Date: Feb, 05 2026
                  final String formattedDate = DateFormat('MMM, dd yyyy').format(dateValue);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Weight on the left
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "$weightValue",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "kg",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),

                        // Date on the right
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
