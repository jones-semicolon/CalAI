import 'package:calai/onboarding/auth_entry/sign_in_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../pages/auth/auth.dart';
import '../../widgets/language_card.dart';

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
            padding: const EdgeInsets.only(
              right: 24,
              left: 24,
              top: 5,
              bottom: 25,
            ),
            child: Column(
              children: [
                /// TOP RIGHT LANGUAGE BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Theme.of(context).colorScheme.onTertiary,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() => _showLanguagePicker = true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Row(
                            children: const [
                              Text('🇺🇸', style: TextStyle(fontSize: 11)),
                              SizedBox(width: 4),
                              Text(
                                'EN',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  textAlign: TextAlign.center,
                  'Calorie tracking made easy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () => widget.onGetStarted(),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, _, _) => const SignInPage(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                            decorationColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
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
