import 'package:flutter/material.dart';

/// A page that allows the user to edit their name.
///
/// This page is stateful to manage the text input controller and the enabled
/// state of the "Done" button.
class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  // --- State --- //
  final _controller = TextEditingController();
  bool _hasInput = false;

  // --- Lifecycle --- //
  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleInputChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleInputChange);
    _controller.dispose();
    super.dispose();
  }

  // --- Handlers --- //

  /// Updates the [_hasInput] state based on the text controller's content.
  void _handleInputChange() {
    setState(() {
      _hasInput = _controller.text.trim().isNotEmpty;
    });
  }

  /// Handles the tap on the "Done" button.
  void _handleDone() {
    if (!_hasInput) return; // Safeguard
    // TODO: Save name to user profile or local storage
    print("Done pressed, name: ${_controller.text}");
    if (mounted) {
      Navigator.pop(context);
    }
  }

  // --- Build --- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _EditNameAppBar(),
      body: Column(
        children: [
          _PageBody(controller: _controller),
          const Spacer(),
          // The footer is separate to float above the content and have a shadow.
          _DoneFooter(
            hasInput: _hasInput,
            onDone: _handleDone,
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

  const _DoneFooter({required this.hasInput, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        // Use a theme-aware color. The shadow won't show without a solid color.
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -0.5), // Shadow positioned above the container.
            blurRadius: 5,
          ),
        ],
      ),
      child: _DoneButton(
        // Pass the done handler, which will be null if there is no input.
        onPressed: hasInput ? onDone : null,
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