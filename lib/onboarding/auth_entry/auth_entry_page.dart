import 'package:calai/l10n/l10n.dart';
import 'package:calai/onboarding/auth_entry/sign_in_sheet.dart';
import 'package:calai/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/language_card.dart';

class AuthEntryPage extends ConsumerStatefulWidget {
  final VoidCallback onGetStarted;

  const AuthEntryPage({super.key, required this.onGetStarted});

  @override
  ConsumerState<AuthEntryPage> createState() => _AuthEntryPageState();
}

class _AuthEntryPageState extends ConsumerState<AuthEntryPage> {
  bool _showLanguagePicker = false;

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider) ?? Localizations.localeOf(context);
    final localeCode = locale.languageCode.toUpperCase();
    final localeFlag = _flagForLanguageCode(locale.languageCode);

    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24, top: 5, bottom: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Theme.of(context).colorScheme.onTertiary,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => setState(() => _showLanguagePicker = true),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              Text(localeFlag, style: const TextStyle(fontSize: 11)),
                              const SizedBox(width: 4),
                              Text(
                                localeCode,
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
                  context.l10n.calorieTrackingMadeEasy,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: widget.onGetStarted,
                    child: Text(
                      context.l10n.getStarted,
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
                      '${context.l10n.alreadyAccount} ',
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
                          text: context.l10n.signIn,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                            decorationColor: Theme.of(context).colorScheme.primary,
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
          if (_showLanguagePicker)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: LanguageCard(
                  onClose: () => setState(() => _showLanguagePicker = false),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _flagForLanguageCode(String code) {
    switch (code) {
      case 'es':
        return '🇪🇸';
      case 'pt':
        return '🇵🇹';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'it':
        return '🇮🇹';
      case 'hi':
        return '🇮🇳';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
