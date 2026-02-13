import 'package:calai/l10n/app_localizations.dart';
import 'package:calai/onboarding/auth_entry/sign_in_sheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_card.dart';

class AuthEntryPage extends StatefulWidget {
  final VoidCallback onGetStarted;

  const AuthEntryPage({super.key, required this.onGetStarted});

  @override
  State<AuthEntryPage> createState() => _AuthEntryPageState();
}

class _AuthEntryPageState extends State<AuthEntryPage> {
  bool _showLanguagePicker = false;
  String _selectedLanguageCode = 'us';

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(LanguageCard.languageStorageKey) ?? 'us';
    if (!mounted) return;
    setState(() => _selectedLanguageCode = saved);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                      color: Theme.of(context).colorScheme.secondary,
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
                            children: [
                              Text(
                                LanguageCard.flagForCode(_selectedLanguageCode),
                                style: const TextStyle(fontSize: 11),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                LanguageCard.labelForCode(_selectedLanguageCode),
                                style: const TextStyle(
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
                  t.calorieTrackingMadeEasy,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: widget.onGetStarted,
                    child: Text(
                      t.getStarted,
                      style: TextStyle(
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor,
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
                      t.alreadyAccount,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
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
                            pageBuilder: (_, __, ___) => const SignInPage(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: t.signIn,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                            decorationColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
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
                  onLanguageChanged: (code) {
                    setState(() => _selectedLanguageCode = code);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
