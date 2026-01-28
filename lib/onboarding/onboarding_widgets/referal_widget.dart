import 'package:flutter/material.dart';

class ReferralCodeInput extends StatefulWidget {
  final void Function(String referralCode) onSubmit;
  final TextEditingController? controller;

  const ReferralCodeInput({super.key, required this.onSubmit, this.controller});

  @override
  State<ReferralCodeInput> createState() => _ReferralCodeInputState();
}

class _ReferralCodeInputState extends State<ReferralCodeInput> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _hasText = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(
      () => _hasText.value = _controller.text.trim().isNotEmpty,
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focusNode.dispose();
    _hasText.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSubmit(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge([_focusNode, _controller]),
      builder: (_, _) {
        final isActive = _focusNode.hasFocus || _controller.text.isNotEmpty;

        return Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.onTertiary,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? Border.all(color: colors.primary, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      top: isActive ? 0 : 10,
                      left: 0,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        style: TextStyle(
                          fontSize: isActive ? 11 : 14,
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                        child: const Text('Referral Code'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ValueListenableBuilder<bool>(
                valueListenable: _hasText,
                builder: (_, active, _) {
                  return ElevatedButton(
                    onPressed: active ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: theme.colorScheme.primary, // active
                      disabledBackgroundColor: theme.disabledColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 17,
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: theme.scaffoldBackgroundColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
