// ------------------------------------------------------------
// RECENTLY LOGGED SECTION
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/l10n/l10n.dart';

import '../../../enums/food_enums.dart';
import '../../../models/exercise_model.dart';
import '../../../models/food_model.dart';
import '../../../providers/entry_streams_provider.dart';
import '../../../providers/user_provider.dart';
import '../home_body.dart';
import 'log_card.dart';

class RecentlyUploadedSection extends ConsumerWidget {
  final String dateId;
  const RecentlyUploadedSection({super.key, required this.dateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(dailyEntriesProvider(dateId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.recentlyLoggedTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // TextButton(
              //   onPressed: () {
              //     // TODO: Navigate to your full history view
              //     debugPrint("Navigating to all logs for $dateId");
              //   },
              //   child: Text("See all"),
              // ),
            ]
          ),
          const SizedBox(height: 20),
          entriesAsync.when(
            skipLoadingOnReload: true,
            loading: () => const EmptyState(),
            error: (e, _) => Text(context.l10n.errorLoadingLogs(e.toString())),
            data: (entries) {
              if (entries.isEmpty) {
                return const EmptyState();
              }

              // ✅ 1. Create a copy to sort (entries from Riverpod are immutable)
              final sortedEntries = List<Map<String, dynamic>>.from(entries);

              // ✅ 2. Sort by timestamp (Descending: Newest first)
              sortedEntries.sort((a, b) {
                final aTime = _parseDateTime(a['timestamp']);
                final bTime = _parseDateTime(b['timestamp']);
                return bTime.compareTo(aTime);
              });

              return Column(
                children: sortedEntries.take(5).map((data) { // Use sorted list
                  final category = data['source'] ?? '';

                  return buildLogItem(
                    data,
                    onDelete: () {
                      final logItem = category == SourceType.exercise.value
                          ? ExerciseLog.fromJson(data)
                          : FoodLog.fromJson(data);

                      ref.read(userProvider.notifier).deleteEntry(
                        dateId: dateId,
                        item: logItem,
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

DateTime _parseDateTime(dynamic timestamp) {
  if (timestamp is DateTime) return timestamp;
  if (timestamp is String) return DateTime.tryParse(timestamp) ?? DateTime.now();
  // If it's a Firestore Timestamp object
  if (timestamp.runtimeType.toString() == 'Timestamp') {
    return timestamp.toDate();
  }
  return DateTime.now();
}
