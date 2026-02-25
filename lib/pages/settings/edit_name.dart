import 'package:calai/services/calai_firestore_service.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
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
    final currentName = ref.read(userProvider).profile.name;
    _controller = TextEditingController(text: currentName);
    _hasInput = currentName!.trim().isNotEmpty;

    _controller.addListener(_handleInputChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleInputChange() {
    setState(() {
      _hasInput = _controller.text.trim().isNotEmpty;
    });
  }

  Future<void> _handleDone() async {
    if (!_hasInput) return;

    final newName = _controller.text.trim();

    ref.read(userProvider.notifier).setName(newName);

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
          const Text(
            "Edit name",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _NameInputField(controller: controller),
        ],
      ),
    );
  }
}

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