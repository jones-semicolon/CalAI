import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/global_data.dart';
import '../../data/user_data.dart';

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
    final currentName = ref.read(userProvider).name;
    _controller = TextEditingController(text: currentName);
    _hasInput = currentName.trim().isNotEmpty;

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
    await ref.read(globalDataProvider.notifier).updateProfile();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalAsync = ref.watch(globalDataProvider);
    final isSaving = globalAsync.isLoading;

    return Scaffold(
      appBar: const _EditNameAppBar(),
      body: Column(
        children: [
          _PageBody(controller: _controller),
          const Spacer(),
          _DoneFooter(
            hasInput: _hasInput && !isSaving,
            onDone: _handleDone,
            isSaving: isSaving,
          ),
        ],
      ),
    );
  }
}

// --- Private UI Widgets --- //

/// The custom AppBar for the Edit Name page.
class _EditNameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _EditNameAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        // This style creates the circular background button effect.
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            const Color.fromARGB(255, 249, 248, 253),
          ),
        ),
      ),
      // Empty title as the title is in the body.
      title: const Text(""),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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

/// The text input field for the user's name.
class _NameInputField extends StatelessWidget {
  final TextEditingController controller;

  const _NameInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // style: TextStyle(color: Theme.of(context).colorScheme.primary),
      decoration: InputDecoration(
        hintText: "Enter your name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.primary,
          ),
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
              : const Text("Done", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

/// The final "Done" button with enabled/disabled states.
class _DoneButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _DoneButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          // resolveWith handles the button's appearance in different states.
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade400; // Disabled color
            }
            return Colors.black; // Enabled color
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade700;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
        child: const Text(
          "Done",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}