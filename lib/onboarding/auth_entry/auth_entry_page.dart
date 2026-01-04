import 'package:calai/onboarding/auth_entry/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'language_card.dart';

class AuthEntryPage extends StatefulWidget {
  final VoidCallback onGetStarted;

  const AuthEntryPage({super.key, required this.onGetStarted});

  @override
  State<AuthEntryPage> createState() => _AuthEntryPageState();
}

class _AuthEntryPageState extends State<AuthEntryPage> {
  bool _showLanguagePicker = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          /// MAIN CONTENT
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                /// TOP RIGHT LANGUAGE BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() => _showLanguagePicker = true);
                      },
                      child: Row(
                        children: const [
                          Text('🇺🇸', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 6),
                          Text(
                            'EN',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  'Welcome to Cal AI',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'Track smarter. Eat better.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: widget.onGetStarted,
                    child: const Text('Get Started'),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInPage(),
                      ),
                    );
                  },
                  child: const Text('Already have an account? Sign in'),
                ),
              ],
            ),
          ),

          /// LANGUAGE PICKER OVERLAY
          if (_showLanguagePicker)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: LanguageCard(
                  onClose: () {
                    setState(() => _showLanguagePicker = false);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
