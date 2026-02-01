// ------------------------------------------------------------
// RECENTLY LOGGED SECTION
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/global_data.dart';
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
          const Text(
            "Recently logged",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          entriesAsync.when(
            skipLoadingOnReload: true,
            loading: () => EmptyState(),
            error: (e, _) => Text("Error loading logs: $e"),
            data: (entries) {
              if (entries.isEmpty) {
                return const EmptyState();
              }

              return Column(
                children: [
                  for (final data in entries) buildLogItem(data as Map<String, dynamic>),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

