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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 30),
                _buildNameInputField(context),
              ],
            ),
          ),
          const Spacer(),
          _buildDoneContainer(),
        ],
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
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Color.fromARGB(255, 249, 248, 253),
          ),
        ),
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
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  /// --------------------------
  /// NAME INPUT FIELD
  /// --------------------------
  Widget _buildNameInputField(BuildContext context) {
    return TextField(
      controller: _controller,
      // style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      // cursorColor: Theme.of(context).colorScheme.onPrimary,
      decoration: InputDecoration(
        hintText: "Enter your name",
        maintainHintSize: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 3, // thickness when focused
            // color: Colors.black,
          ),
        ),
      ),
    );
  }

  /// --------------------------
  /// DONE BUTTON
  /// --------------------------

  Widget _buildDoneContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white, // 👈 REQUIRED or shadow won't show
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -0.5), // 👈 shadow ABOVE
            blurRadius: 5,
          ),
        ],
      ),
      child: _buildDoneButton(),
    );
  }

  Widget _buildDoneButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: hasInput ? _handleDone : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade400; // 👈 disabled color
            }
            return Colors.black; // enabled
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

  /// --------------------------
  /// DONE BUTTON HANDLER
  /// --------------------------
  void _handleDone() {
    // TODO: Save name to user profile or local storage
    print("Done pressed, name: ${_controller.text}");
    Navigator.pop(context);
  }
}
