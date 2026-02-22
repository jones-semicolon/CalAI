import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/food_model.dart';
import '../services/calai_firestore_service.dart';

// 1. Saved Foods Stream
final savedFoodsStreamProvider = StreamProvider<List<Food>>((ref) {
  final service = ref.watch(calaiServiceProvider);

  if (service.uid == null) return const Stream.empty();

  return service.savedFoodCol
      .orderBy('savedAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      if (data['savedAt'] is Timestamp) {
        data['savedAt'] = (data['savedAt'] as Timestamp).toDate().toIso8601String();
      }
      return Food.fromDoc(data);
    }).toList();
  });
});

// 2. Daily Entries Stream (Family allows passing dateId)
final dailyEntriesProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, dateId) {
  final service = ref.watch(calaiServiceProvider);

  if (service.uid == null) return const Stream.empty();

  return service.dailyLogDoc(dateId)
      .collection('entries')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});