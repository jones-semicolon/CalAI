import 'dart:convert';
import 'package:calai/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class DebugOverlay extends ConsumerStatefulWidget {
  const DebugOverlay({super.key});

  @override
  ConsumerState<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends ConsumerState<DebugOverlay> {
  bool _isExpanded = false;
  bool _showGlobal = true; // Toggle between User and Global data

  @override
  Widget build(BuildContext context) {
    // 1. WATCH both providers
    final user = ref.watch(userProvider);
    final globalAsync = ref.watch(globalDataProvider);

    // 2. Format JSON strings
    final userJson = const JsonEncoder.withIndent('  ').convert(user.toJson());

    // Handle Global Data (it's an AsyncValue)
    String globalJson = "Loading...";
    globalAsync.when(
      data: (state) => globalJson = const JsonEncoder.withIndent('  ').convert(state.toJson()),
      error: (e, _) => globalJson = "Error: $e",
      loading: () => globalJson = "Loading Global State...",
    );

    return Positioned(
      top: 100, // Lowered slightly
      right: 0,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: _isExpanded ? 350 : 60,
          height: _isExpanded ? 500 : 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            border: Border.all(color: _showGlobal ? Colors.cyanAccent : Colors.greenAccent, width: 1.5),
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
                      Icon(
                          _isExpanded ? Icons.terminal : Icons.bug_report,
                          color: _showGlobal ? Colors.cyanAccent : Colors.greenAccent,
                          size: 20
                      ),
                      if (_isExpanded) ...[
                        Text(
                          _showGlobal ? "GLOBAL STATE" : "USER MASTER",
                          style: TextStyle(
                            color: _showGlobal ? Colors.cyanAccent : Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
                          onPressed: () => setState(() => _showGlobal = !_showGlobal),
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
                        _showGlobal ? globalJson : userJson,
                        style: TextStyle(
                          color: _showGlobal ? Colors.cyanAccent.withOpacity(0.9) : Colors.greenAccent.withOpacity(0.9),
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