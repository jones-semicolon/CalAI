import 'package:calai/onboarding/onboarding_widgets/header.dart';
import 'package:calai/services/calai_firestore_service.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_widgets/referal_widget.dart';

class OnboardingStep16 extends ConsumerWidget {
  final VoidCallback nextPage;
  const OnboardingStep16({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get the current user UID (assuming you have an auth provider)
    final uid = ref.watch(calaiServiceProvider).uid; 

    Future<void> handleReferral(String code) async {
      debugPrint(uid);
      if (uid == null) return;

      try {
        // Show a loading indicator if you want, or just run the logic
        await ReferralService().redeemReferralCode(code, uid);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Referral applied!')),
          );
          // Optional: Auto-advance after successful referral
          nextPage(); 
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }

    return SafeArea(
      child: Column(
        children: [
          const Header(
            title: 'Enter referral code (optional)',
            subtitle: 'You can skip this step',
          ),
          const Spacer(),

          // 2. Pass the new handler
          ReferralCodeInput(onSubmit: handleReferral),

          const Spacer(),
          // Use your existing confirmation button to move to the next screen
          ConfirmationButtonWidget(onConfirm: nextPage, text: 'Skip'),
        ],
      ),
    );
  }
}