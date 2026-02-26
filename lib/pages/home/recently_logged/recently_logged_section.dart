// ------------------------------------------------------------
// RECENTLY LOGGED SECTION
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
              const Text(
                "Recently logged",
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
            error: (e, _) => Text("Error loading logs: $e"),
            data: (entries) {
              if (entries.isEmpty) {
                return const EmptyState();
              }

              final sortedEntries = List<Map<String, dynamic>>.from(entries);

              sortedEntries.sort((a, b) {
                final aTime = _parseDateTime(a['timestamp']);
                final bTime = _parseDateTime(b['timestamp']);
                return bTime.compareTo(aTime);
              });

              return SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: Column(
                  children: sortedEntries.take(5).map((data) {
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
                ),
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
  if (timestamp.runtimeType.toString() == 'Timestamp') {
    return timestamp.toDate();
  }
  return DateTime.now();
}