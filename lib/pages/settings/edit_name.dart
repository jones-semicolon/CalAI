import 'package:calai/services/calai_firestore_service.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/global_provider.dart';
import '../../providers/user_provider.dart';
/// A page that allows the user to edit their name.
///
/// This page is stateful to manage the text input controller and the enabled
/// state of the "Done" button.
class EditNamePage extends ConsumerStatefulWidget {
  const EditNamePage({super.key});

  @override
  ConsumerState<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends ConsumerState<EditNamePage> {
  late final TextEditingController _controller;
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    // 1. Initialize with current name from Riverpod
    final currentName = ref.read(userProvider).profile.name;
    _controller = TextEditingController(text: currentName);
    _hasInput = currentName!.trim().isNotEmpty;

    _controller.addListener(_handleInputChange);
  }

  @override
  void dispose() {
    _controller.dispose(); // No need to remove listener explicitly if disposing
    super.dispose();
  }

  void _handleInputChange() {
    setState(() {
      _hasInput = _controller.text.trim().isNotEmpty;
    });
  }

  /// Handles saving the name to both Riverpod and Firestore
  Future<void> _handleDone() async {
    if (!_hasInput) return;

    final newName = _controller.text.trim();

    // 2. Update local Riverpod state (instant UI feedback)
    ref.read(userProvider.notifier).setName(newName);

    // 3. Persist to Firestore using the updateProfile method in GlobalData
    // We already cleaned this method to save the 'name' field
    await ref.read(calaiServiceProvider).updateUserProfileField('name', newName);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalAsync = ref.watch(globalDataProvider);
    final isSaving = globalAsync.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: SizedBox.shrink()),
            _PageBody(controller: _controller),
            const Spacer(),
            ConfirmationButtonWidget(onConfirm: _handleDone, enabled: _hasInput && !isSaving,)
          ],
        ),
      ),
    );
  }
}

/// The main content area of the page, including the title and input field.
class _PageBody extends StatelessWidget {
  final TextEditingController controller;

  const _PageBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.editNameTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _NameInputField(controller: controller),
        ],
      ),
    );
  }
}

/// The text input field for the user's name.
class _NameInputField extends StatelessWidget {
  final TextEditingController controller;

  const _NameInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.45),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

/// The floating footer container that provides the background and shadow for the button.
class _DoneFooter extends StatelessWidget {
  final bool hasInput;
  final VoidCallback onDone;
  final bool isSaving;

  const _DoneFooter({
    required this.hasInput,
    required this.onDone,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -0.5),
            blurRadius: 5,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: hasInput ? onDone : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade400,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: isSaving
              ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          )
              : Text(context.l10n.doneLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
