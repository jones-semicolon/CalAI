import 'package:calai/enums/user_enums.dart';
import 'package:calai/providers/user_provider.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../providers/global_provider.dart';

class WeightHistoryView extends ConsumerStatefulWidget {
  const WeightHistoryView({super.key});

  @override
  ConsumerState<WeightHistoryView> createState() => _WeightHistoryViewState();
}

class _WeightHistoryViewState extends ConsumerState<WeightHistoryView> {
  @override
  Widget build(BuildContext context) {
    // 1. Watch the global data
    final globalAsync = ref.watch(globalDataProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: Text(context.l10n.weightHistory)),

            // 2. Handle Loading/Error/Data states
            Expanded(
              child: globalAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text(context.l10n.unableToLoadProgress(error))),
                data: (global) {
                  // 3. Get logs and Sort them (Newest first)
                  final logs = global.weightLogs;
                  final unitSystem = ref.read(userProvider).settings.measurementUnit;

                  if (logs.isEmpty) {
                    return Center(
                      child: Text(
                        context.l10n.noWeightHistoryYet,
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    );
                  }

                  // Create a sorted copy to avoid mutating the original list
                  final sortedLogs = List.of(logs)
                    ..sort((a, b) => b.date.compareTo(a.date));

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedLogs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final log = sortedLogs[index];
                      final double displayWeight = unitSystem?.metricToDisplay(log.weight)  ?? log.weight;

                      // 4. Format real data
                      final String formattedDate = DateFormat('MMM, dd yyyy').format(log.date);

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
                            // Weight Value
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  // Ensure uniform decimal places (e.g., 70.0)
                                  displayWeight.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  unitSystem?.weightLabel ?? MeasurementUnit.metric.weightLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),

                            // Date Label
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
