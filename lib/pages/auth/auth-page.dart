import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth.dart'; // <--- 1. IMPORT YOUR AUTH FILE

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  // --- State --- //
  final _controller = TextEditingController();
  bool _hasInput = false;
  bool _isLoading = false; // <--- 2. ADD LOADING STATE

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

  void _handleInputChange() {
    setState(() {
      _hasInput = _controller.text.trim().isNotEmpty;
    });
  }

  /// Handles the tap on the "Done" button.
  Future<void> _handleDone() async {
    if (!_hasInput) return;

    final email = _controller.text.trim();

    // Basic email validation regex
    final bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!emailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    // 3. START LOADING
    setState(() => _isLoading = true);

    try {
      // 4. CALL YOUR FUNCTION
      // await sendMagicLink(email);
      AuthService.sendMagicLink(email);
      if (mounted) {
        // 5. SHOW SUCCESS MESSAGE
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Check your email'),
            content: Text('We sent a sign-in link to $email'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Optional: Navigator.pop(context); // Go back to login screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      // 6. STOP LOADING
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- Build --- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AuthPageAppBar(),
      body: Column(
        children: [
          _PageBody(controller: _controller),
          const Spacer(),
          _DoneFooter(
            hasInput: _hasInput,
            isLoading: _isLoading, // <--- Pass loading state down
            onDone: _handleDone,
          ),
        ],
      ),
    );
  }
}

// --- Private UI Widgets --- //

class _AuthPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AuthPageAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            const Color.fromARGB(255, 249, 248, 253),
          ),
        ),
      ),
      title: const Text(""),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
            "What's your email?", // Changed "Email" to be more conversational
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "We'll send you a link to sign in without a password.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          _EmailInputField(controller: controller),
        ],
      ),
    );
  }
}

class _EmailInputField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress, // Optimize keyboard for email
      autofocus: true, // Focus automatically so user can type immediately
      decoration: InputDecoration(
        hintText: "name@example.com",
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

class _DoneFooter extends StatelessWidget {
  final bool hasInput;
  final bool isLoading;
  final VoidCallback onDone;

  const _DoneFooter({
    required this.hasInput,
    required this.isLoading,
    required this.onDone,
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
      child: _DoneButton(
        onPressed: hasInput && !isLoading ? onDone : null, // Disable if loading
        isLoading: isLoading, // Pass loading state
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _DoneButton({this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade400;
            }
            return Colors.black;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade700;
            }
            return Colors.white;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          "Continue",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}