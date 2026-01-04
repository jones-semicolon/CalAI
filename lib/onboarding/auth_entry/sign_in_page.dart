import 'package:flutter/material.dart';
import 'sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Spacer(),

                  Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Theme.of(context).dividerColor),

            /// CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// GOOGLE SIGN IN
                    SignInButton(
                      icon: Icons.g_mobiledata,
                      text: 'Sign in with Google',
                      onTap: () {},
                    ),

                    const SizedBox(height: 16),

                    /// EMAIL SIGN IN
                    SignInButton(
                      icon: Icons.email_outlined,
                      text: 'Sign in with Email',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            /// FOOTER TEXT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    const TextSpan(text: 'By continuing, you agree to Cal AI\'s '),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: const TextStyle(decoration: TextDecoration.underline),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(decoration: TextDecoration.underline),
                    ),
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
