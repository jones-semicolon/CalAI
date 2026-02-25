// providers/navigation_provider.dart
import 'package:flutter_riverpod/legacy.dart';

// Keeps track of the bottom nav index (0: Home, 1: Progress, etc.)
final selectedPageProvider = StateProvider<int>((ref) => 0);