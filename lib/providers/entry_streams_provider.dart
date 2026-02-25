import 'package:calai/providers/auth_state_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/food_model.dart';
import '../services/calai_firestore_service.dart';

// 1. Saved Foods Stream
final savedFoodsStreamProvider =
    StreamProvider.autoDispose<List<Food>>((ref) {
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

final dailyEntriesProvider =
    StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>(
        (ref, dateId) {
          
  if (dateId.isEmpty) {
    return const Stream.empty();
  }

  final authAsync = ref.watch(authStateProvider);

  if (!authAsync.hasValue || authAsync.value == null) {
    return const Stream.empty();
  }

  final service = ref.watch(calaiServiceProvider);

  if (service.uid == null) return const Stream.empty();

  return service
      .dailyLogDoc(dateId)
      .collection('entries')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .handleError((error) {
        if (error is FirebaseException && error.code == 'permission-denied') {
          debugPrint(
              'Swallowed Firestore permission-denied in dailyEntriesProvider.');
        } else {
          throw error;
        }
      })
      .map((snapshot) =>
          snapshot.docs.map((doc) => doc.data()).toList());
});