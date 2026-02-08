import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoalInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String label;

  const GoalInputField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      cursorColor: scheme.primary, // caret color
      style: TextStyle(color: scheme.primary),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(color: scheme.primary),
        floatingLabelStyle: TextStyle(color: scheme.primary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.onTertiaryFixed, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
    );
  }
}
