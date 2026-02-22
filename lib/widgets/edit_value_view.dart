import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditModal extends StatefulWidget {
  final double initialValue;
  final String title;
  final String label;
  final Color color;
  final Function(double) onDone;

  const EditModal({
    super.key,
    required this.initialValue,
    required this.title,
    required this.label,
    required this.color,
    required this.onDone,
  });

  @override
  State<EditModal> createState() => _EditModalState();
}

class _EditModalState extends State<EditModal> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue % 1 == 0
          ? widget.initialValue.toInt().toString()
          : widget.initialValue.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use Padding with MediaQuery to handle the keyboard pushing the modal up
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Revert
          // Body
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit ${widget.title}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _controller.text = widget.initialValue % 1 == 0
                              ? widget.initialValue.toInt().toString()
                              : widget.initialValue.toString();
                        });
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text("Revert"),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Label and Input
                Text(widget.label, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  autofocus: true, // Opens keyboard immediately
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: widget.color, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Primary Done Button
          ConfirmationButtonWidget(
            onConfirm: () {
              // 1. Parse the text into a double (fallback to initial if empty/invalid)
              final newValue = double.tryParse(_controller.text) ?? widget.initialValue;

              // 2. Execute the callback with the actual value
              widget.onDone(newValue);
            },
          )
        ],
      ),
    );
  }
}