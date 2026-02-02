import 'package:flutter/material.dart';
import 'widgets/summary_card.dart';
import 'widgets/input_field.dart';
import 'widgets/bottom_actions.dart';

class EditGoalScreen extends StatefulWidget {
  final int initialValue;
  final String title;
  final IconData icon;
  final Color color; // accent color

  const EditGoalScreen({
    super.key,
    required this.initialValue,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  late final TextEditingController _controller;
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = TextEditingController(text: _value.toString());
  }

  void _onChanged(String v) {
    final parsed = int.tryParse(v);
    if (parsed != null) setState(() => _value = parsed);
  }

  void _revert() {
    setState(() {
      _value = widget.initialValue;
      _controller.text = widget.initialValue.toString();
    });
  }

  void _done() {
    final v = int.tryParse(_controller.text);
    if (v != null) Navigator.pop(context, v);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: scheme.secondary,
            shape: const CircleBorder(),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: scheme.onPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit ${widget.title} Goal',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),

            // Static visual indicator only
            SummaryCard(value: _value, icon: widget.icon, color: widget.color),

            const SizedBox(height: 32),

            // Numeric input
            GoalInputField(
              label: widget.title,
              controller: _controller,
              onChanged: _onChanged,
            ),

            const Spacer(),
            BottomActions(onRevert: _revert, onDone: _done),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
