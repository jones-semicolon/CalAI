import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'widgets/summary_card.dart';
import 'widgets/input_field.dart';
import 'widgets/bottom_actions.dart';

class EditGoalScreen extends StatefulWidget {
  final num initialValue;
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
  late num _value;

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Use an outer Column to manage the layout
      body: Column(
        children: [
          const CustomAppBar(title: SizedBox.shrink()),
          // Wrap the content in an Expanded to give the Spacer room to work
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit ${widget.title} Goal',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 24),
                  SummaryCard(value: _value, icon: widget.icon, color: widget.color),
                  const SizedBox(height: 32),
                  GoalInputField(
                    label: widget.title,
                    controller: _controller,
                    onChanged: _onChanged,
                  ),

                  // Now Spacer works because its parent (Column) is inside an Expanded
                  const Spacer(),

                  BottomActions(onRevert: _revert, onDone: _done),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
