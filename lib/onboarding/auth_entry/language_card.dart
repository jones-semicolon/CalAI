import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final VoidCallback onClose;

  const LanguageCard({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            /// HEADER
            Row(
              children: [
                const Spacer(),
                Text(
                  'Choose language',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// LANGUAGE LIST CARD
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  children: const [
                    LanguageItem(flag: '🇺🇸', language: 'English'),
                    LanguageItem(flag: '🇪🇸', language: 'Español'),
                    LanguageItem(flag: '🇵🇹', language: 'Português'),
                    LanguageItem(flag: '🇫🇷', language: 'Français'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageItem extends StatelessWidget {
  final String flag;
  final String language;

  const LanguageItem({
    super.key,
    required this.flag,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        // TODO: handle language selection
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              language,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
