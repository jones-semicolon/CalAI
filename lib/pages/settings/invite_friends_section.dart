import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';

class InviteFriendsSection extends StatelessWidget {
  const InviteFriendsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.onPrimary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.group_outlined, size: 20, color: primaryColor),
          const SizedBox(width: 10),
          Text(
            context.tr("Invite friends"),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
