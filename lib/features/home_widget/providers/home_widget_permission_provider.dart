import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/home_widget_service.dart';

final homeWidgetPermissionProvider = StateProvider.family<bool, HomeWidgetKind>(
  (ref, kind) => false,
);

Future<bool> refreshHomeWidgetPermission(
  WidgetRef ref,
  HomeWidgetKind kind,
) async {
  final pinned = await HomeWidgetService.isWidgetPinned(kind: kind);
  ref.read(homeWidgetPermissionProvider(kind).notifier).state = pinned;
  return pinned;
}

Future<bool> requestHomeWidgetPermission(
  WidgetRef ref,
  HomeWidgetKind kind,
) async {
  final canRequest = await HomeWidgetService.requestPinWidget(kind: kind);
  if (!canRequest) {
    final pinned = await HomeWidgetService.isWidgetPinned(kind: kind);
    ref.read(homeWidgetPermissionProvider(kind).notifier).state = pinned;
    return pinned;
  }

  // Android may update pinned widget state with a short delay.
  for (var i = 0; i < 8; i++) {
    final pinned = await HomeWidgetService.isWidgetPinned(kind: kind);
    if (pinned) {
      ref.read(homeWidgetPermissionProvider(kind).notifier).state = true;
      return true;
    }
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  ref.read(homeWidgetPermissionProvider(kind).notifier).state = false;
  return false;
}
