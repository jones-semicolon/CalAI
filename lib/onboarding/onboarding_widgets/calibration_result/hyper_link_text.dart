import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_constants.dart';

class HyperlinkText extends StatelessWidget {
  final String text;
  final String url;

  const HyperlinkText({super.key, required this.text, required this.url});

  Future<void> _openLink() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppTextStyles.headTitle.copyWith(
          color: AppColors.primary(context),
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.normal,
          wordSpacing: 2.0,
          decorationThickness: 1.5, 
        ),
        recognizer: TapGestureRecognizer()..onTap = _openLink,
      ),
    );
  }
}
