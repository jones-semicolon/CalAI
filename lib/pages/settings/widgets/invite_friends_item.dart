import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

/// A simple, tappable list item for the "Invite friends" action.
class InviteFriendsItem extends StatelessWidget {
  const InviteFriendsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleMedium;
    final primaryColor = theme.colorScheme.primary;

    return Container(
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
        ],
      ),
    );
  }
}
