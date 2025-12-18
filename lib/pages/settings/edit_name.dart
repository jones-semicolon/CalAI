import 'package:flutter/material.dart';

/// Page to edit the user's name
class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final TextEditingController _controller = TextEditingController();
  bool hasInput = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleInputChange);
  }

  void _handleInputChange() {
    setState(() {
      hasInput = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleInputChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 20),
            _buildNameInputField(context),
            const Spacer(),
            _buildDoneButton(),
          ],
        ),
      ),
    );
  }

  /// --------------------------
  /// APP BAR
  /// --------------------------
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(""),
      elevation: 0,
    );
  }

  /// --------------------------
  /// PAGE TITLE
  /// --------------------------
  Widget _buildTitle() {
    return const Text(
      "Edit name",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  /// --------------------------
  /// NAME INPUT FIELD
  /// --------------------------
  Widget _buildNameInputField(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: "Enter your name",
        counterStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// --------------------------
  /// DONE BUTTON
  /// --------------------------
  Widget _buildDoneButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: hasInput ? _handleDone : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasInput ? Colors.black : Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          "Done",
          style: TextStyle(
            color: hasInput ? Colors.white : Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// --------------------------
  /// DONE BUTTON HANDLER
  /// --------------------------
  void _handleDone() {
    // TODO: Save name to user profile or local storage
    print("Done pressed, name: ${_controller.text}");
    Navigator.pop(context);
  }
}
