import 'package:calai/pages/settings/screens/referral_view.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

// ✅ Make sure to import your ReferralView here
// import 'package:calai/features/profile/referral_view.dart'; // Update with your actual path

/// A simple, tappable list item for the "Invite friends" action.
class InviteFriendsItem extends StatelessWidget {
  const InviteFriendsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleMedium;
    final primaryColor = theme.colorScheme.primary;

    // ✅ 1. Wrap the container in a GestureDetector
    return GestureDetector(
      onTap: () {
        // ✅ 2. Push the ReferralView onto the navigation stack
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ReferralView(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          boxShadow: [
            BoxShadow(
              color: theme.splashColor.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Icon(Icons.group_outlined, size: 20, color: primaryColor),
            ),
            const SizedBox(width: 10),
            Text("Invite friends", style: textStyle),
            
            const Spacer(),
            
            // ✅ 3. Added a chevron to visually indicate navigation
            Icon(Icons.chevron_right, color: theme.iconTheme.color, size: 20),
          ],
        ),
      ),
    );
  }
}