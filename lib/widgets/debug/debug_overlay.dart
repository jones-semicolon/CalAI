import 'dart:convert';
import 'package:calai/providers/global_provider.dart';
import 'package:calai/models/food_model.dart'; // Ensure this is imported
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class DebugOverlay extends ConsumerStatefulWidget {
  final Food? food; // ✅ Add the food parameter

  const DebugOverlay({super.key, this.food});

  @override
  ConsumerState<DebugOverlay> createState() => _DebugOverlayState();
}

// 0 = User, 1 = Global, 2 = Food
enum DebugView { user, global, food }

class _DebugOverlayState extends ConsumerState<DebugOverlay> {
  bool _isExpanded = false;
  DebugView _currentView = DebugView.global;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final globalAsync = ref.watch(globalDataProvider);

    // 1. Format JSON strings
    final userJson = const JsonEncoder.withIndent('  ').convert(user.toJson());

    String globalJson = "Loading...";
    globalAsync.when(
      data: (state) => globalJson = const JsonEncoder.withIndent('  ').convert(state.toJson()),
      error: (e, _) => globalJson = "Error: $e",
      loading: () => globalJson = "Loading Global State...",
    );

    // ✅ Format the passed Food object
    final foodJson = widget.food != null
        ? const JsonEncoder.withIndent('  ').convert(widget.food!.toJson())
        : "No Food Selected";

    // Dynamic coloring based on view
    final accentColor = _currentView == DebugView.global
        ? Colors.cyanAccent
        : _currentView == DebugView.user
        ? Colors.greenAccent
        : Colors.orangeAccent;

    String activeJson;
    switch (_currentView) {
      case DebugView.user: activeJson = userJson; break;
      case DebugView.global: activeJson = globalJson; break;
      case DebugView.food: activeJson = foodJson; break;
    }

    return Positioned(
      top: 100,
      right: 0,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: _isExpanded ? 350 : 60,
          height: _isExpanded ? 500 : 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            border: Border.all(color: accentColor, width: 1.5),
          ),
          child: Column(
            children: [
              // --- HEADER ---
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(_isExpanded ? Icons.terminal : Icons.bug_report, color: accentColor, size: 20),
                      if (_isExpanded) ...[
                        Text(
                          _currentView.name.toUpperCase(),
                          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
                          onPressed: () => setState(() {
                            // Cycle through the three views
                            int next = (_currentView.index + 1) % DebugView.values.length;
                            _currentView = DebugView.values[next];
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // --- DATA BODY ---
              if (_isExpanded)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        activeJson,
                        style: TextStyle(
                          color: accentColor.withOpacity(0.9),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}