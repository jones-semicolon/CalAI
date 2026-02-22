import 'package:calai/providers/global_provider.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:calai/features/reminders/data/reminder_settings_repository.dart';
import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/services/notification_service.dart';
import 'package:calai/features/reminders/services/reminder_scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Added
import '../../models/nutrition_model.dart';
import '../onboarding_widgets/header.dart';

// ✅ Changed to ConsumerStatefulWidget
class OnboardingStep13 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep13({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep13> createState() => _OnboardingStep13State();
}

// ✅ Changed to ConsumerState
class _OnboardingStep13State extends ConsumerState<OnboardingStep13>
    with SingleTickerProviderStateMixin {
  bool isAllowNotification = true;
  bool _isSubmitting = false;

  late final AnimationController _controller;
  late final Animation<Offset> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.15),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- Logic ---

  Future<void> _processNotificationAndContinue() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final notificationService = NotificationService();
      bool granted = false;

      // 1. Request Permission if toggled "Allow"
      if (isAllowNotification) {
        granted = await notificationService.requestPermissions();
      }

      // 2. Prepare Settings & Scheduler
      final repository = ReminderSettingsRepository();
      final scheduler = ReminderScheduler(notificationService);
      final currentSettings = await repository.load();

      final updatedSettings = _withAllReminderToggles(
        currentSettings,
        enabled: granted,
      );

      // 3. Save to Local Storage
      await repository.save(updatedSettings);
      await notificationService.initialize();

      // 4. Sync with Provider Data
      if (granted) {
        // ✅ ref is now accessible here
        final globalState = ref.read(globalDataProvider).value;

        if (globalState != null) {
          await scheduler.syncAll(
            settings: updatedSettings,
            goals: NutritionGoals(
              calories: globalState.todayGoal.calories,
              protein: globalState.todayGoal.protein,
              carbs: globalState.todayGoal.carbs,
              fats: globalState.todayGoal.fats,
            ),
          );
        }
      } else {
        await notificationService.cancelAll();
      }

      widget.nextPage();
    } catch (e) {
      debugPrint("❌ Notification Onboarding Error: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  ReminderSettings _withAllReminderToggles(ReminderSettings settings, {required bool enabled}) {
    return settings.copyWith(
      smartNutritionEnabled: enabled,
      waterRemindersEnabled: enabled,
      breakfastReminderEnabled: enabled,
      lunchReminderEnabled: enabled,
      dinnerReminderEnabled: enabled,
      snackReminderEnabled: enabled,
      goalTrackingAlertsEnabled: enabled,
      activityReminderEnabled: enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          const Header(
            title: 'Reach your goals with notifications',
            textAlign: TextAlign.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        child: Text(
                          'Cal AI would like to send you Notifications',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(height: 1.5, color: Theme.of(context).colorScheme.primary.withOpacity(0.25)),
                      Row(
                        children: [
                          _buildToggleButton(label: "Don't Allow", isActive: !isAllowNotification, isLeft: true),
                          _buildToggleButton(label: "Allow", isActive: isAllowNotification, isLeft: false),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: (screenWidth / 1.5),
                  child: SlideTransition(
                    position: _bounceAnimation,
                    child: const Icon(Icons.pan_tool_alt_rounded, size: 40, color: Color.fromARGB(255, 255, 201, 40)),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ✅ Updated to use the new unified method
          ConfirmationButtonWidget(
            enabled: !_isSubmitting,
            onConfirm: _processNotificationAndContinue,
          )
        ],
      ),
    );
  }

  Widget _buildToggleButton({required String label, required bool isActive, required bool isLeft}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isAllowNotification = !isLeft),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: isLeft ? const Radius.circular(15) : Radius.zero,
              bottomRight: !isLeft ? const Radius.circular(15) : Radius.zero,
            ),
            color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}