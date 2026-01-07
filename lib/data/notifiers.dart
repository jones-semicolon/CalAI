import 'package:flutter/material.dart';

/// Notifier to track the currently selected page index in the main navigation.
ValueNotifier<int> selectedPage = ValueNotifier<int>(0);

/// Notifier for managing a user's name change.
final ValueNotifier<String> changeName = ValueNotifier<String>('');