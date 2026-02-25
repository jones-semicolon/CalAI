import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/providers/user_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralView extends ConsumerStatefulWidget {
  const ReferralView({super.key});

  @override
  ConsumerState<ReferralView> createState() => _ReferralViewState();
}

class _ReferralViewState extends ConsumerState<ReferralView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Watch the user provider to get the real referral code
    final user = ref.watch(userProvider);
    final promoCode = user.profile.referralCode ?? "......";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Assumes dark theme
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(title: Text("Refer your friend")),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  
                  // Floating Avatars Graphic
                  const _HeroGraphic(),
                  
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Empower your friends",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "& lose weight together",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                          
                  // Promo Code Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your personal promo code",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              promoCode,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: promoCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Promo code copied!')),
                            );
                          },
                          child: Icon(
                            Icons.copy,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                          
                  // ✅ Share Button Implementation
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // ✅ 2. Use Share.share to trigger native menu
                        final String shareMessage = 
                            "Join me on Cal AI and let's crush our goals together! 🚀\n\n"
                            "Use my personal invite code *$promoCode* when you sign up.\n"
                            "Download here: https://yourapplink.com";
                            
                        Share.share(shareMessage, subject: "Join me on Cal AI!");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Share",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                          
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "How to earn",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFC0866A), // Bronze/Coin color
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.attach_money,
                                size: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const _InstructionBullet(
                          text: "Share your promo code to your friends",
                        ),
                        const SizedBox(height: 12),
                        const _InstructionBullet(
                          text: "Earn \$10 per friend that signs up with your code",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
// --- Helper Widgets ---

class _HeroGraphic extends StatelessWidget {
  const _HeroGraphic();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center Apple Icon
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.apple, // Uses material apple icon, or replace with CupertinoIcons.apple
              color: Colors.black,
              size: 40,
            ),
          ),
          
          // Floating Avatars (Approximated positions from design)
          _buildFloatingAvatar(
            top: 20, left: 30, color: Colors.blue[200]!, size: 45
          ),
          _buildFloatingAvatar(
            top: 10, left: 100, color: Colors.green[400]!, size: 55
          ),
          _buildFloatingAvatar(
            bottom: 30, left: 80, color: Colors.red[300]!, size: 50
          ),
          _buildFloatingAvatar(
            top: 15, right: 90, color: Colors.blue[600]!, size: 50
          ),
          _buildFloatingAvatar(
            bottom: 20, right: 80, color: Colors.purple[300]!, size: 45
          ),
          _buildFloatingAvatar(
            top: 40, right: 20, color: Colors.orange[300]!, size: 40
          ),
        ],
      ),
    );
  }

  // Helper to create the floating circles. 
  // You can replace the Icon with NetworkImage or AssetImage later.
  Widget _buildFloatingAvatar({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required Color color,
    required double size,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 2),
        ),
        child: Icon(
          Icons.person,
          color: Colors.white.withOpacity(0.8),
          size: size * 0.6,
        ),
      ),
    );
  }
}

class _InstructionBullet extends StatelessWidget {
  final String text;

  const _InstructionBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}