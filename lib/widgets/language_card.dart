import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import '../providers/locale_provider.dart';

class LanguageCard extends ConsumerWidget {
  final VoidCallback onClose;

  const LanguageCard({super.key, required this.onClose});

  static const List<_LanguageOption> _languages = [
    _LanguageOption(locale: Locale('en'), flag: '🇺🇸'),
    _LanguageOption(locale: Locale('es'), flag: '🇪🇸'),
    _LanguageOption(locale: Locale('pt'), flag: '🇵🇹'),
    _LanguageOption(locale: Locale('fr'), flag: '🇫🇷'),
    _LanguageOption(locale: Locale('de'), flag: '🇩🇪'),
    _LanguageOption(locale: Locale('it'), flag: '🇮🇹'),
    _LanguageOption(locale: Locale('hi'), flag: '🇮🇳'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(localeProvider);
    final selectedLanguageCode =
        (selectedLocale ?? Localizations.localeOf(context)).languageCode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.chooseLanguage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _languages.length * 2 - 1,
                  (index) {
                    if (index.isEven) {
                      final lang = _languages[index ~/ 2];
                      final languageName = _languageName(context, lang.locale.languageCode);
                      return LanguageItem(
                        flag: lang.flag,
                        language: languageName,
                        isSelected:
                            lang.locale.languageCode == selectedLanguageCode,
                        onTap: () async {
                          await ref
                              .read(localeProvider.notifier)
                              .setLocale(lang.locale);
                          onClose();
                        },
                      );
                    }
                    return const SizedBox(height: 10);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _languageName(BuildContext context, String code) {
    switch (code) {
      case 'es':
        return context.l10n.languageNameSpanish;
      case 'pt':
        return context.l10n.languageNamePortuguese;
      case 'fr':
        return context.l10n.languageNameFrench;
      case 'de':
        return context.l10n.languageNameGerman;
      case 'it':
        return context.l10n.languageNameItalian;
      case 'hi':
        return context.l10n.languageNameHindi;
      case 'en':
      default:
        return context.l10n.languageNameEnglish;
    }
  }
}

class LanguageItem extends StatelessWidget {
  final String flag;
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageItem({
    super.key,
    required this.flag,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.onTertiary,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).splashColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(flag, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 12),
              Text(
                language,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  final Locale locale;
  final String flag;

  const _LanguageOption({
    required this.locale,
    required this.flag,
  });
}
