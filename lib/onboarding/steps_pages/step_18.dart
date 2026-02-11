import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/push_page_route.dart';
import '../../enums/food_enums.dart';
import '../../pages/auth/auth.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/calibration_result/dashboard_widget.dart';
import '../onboarding_widgets/edit_goal/edit_goal_screen.dart';
import '../onboarding_widgets/loading_widget/health_plan_loading_widget.dart';

class OnboardingStep18 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep18({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep18> createState() => OnboardingStep18State();
}

class OnboardingStep18State extends ConsumerState<OnboardingStep18> {
  // UI State Management
  bool _isCalculating = true; // Waiting for API/DB
  bool _isAnimationDone = false; // Waiting for Fancy Animation
  String? _error;

  @override
  void initState() {
    super.initState();
    startComputation();
  }

  Future<void> startComputation() async {
    if (!mounted) return;

    try {
      final userNotifier = ref.read(userProvider.notifier);

      // ✅ THE FIX: Single Responsibility
      // We call this ONE method. It handles:
      // 1. Calculating goals (API)
      // 2. Updating local state
      // 3. Saving everything to Firestore in one batch
      // // ✅ Sign in as guest IMMEDIATELY so they have a UID for the whole onboarding
      if (FirebaseAuth.instance.currentUser == null) {
        await AuthService.signInAsGuest();
      }
      await userNotifier.completeOnboarding();

      if (mounted) {
        setState(() {
          _isCalculating = false;
        });
      }
    } catch (e) {
      debugPrint("Onboarding Error: $e");
      if (mounted) {
        setState(() {
          _isCalculating = false;
          _error = "Could not calculate plan. Please check your connection.";
        });
      }
    }
  }

  Future<void> _editValue({
    required String title,
    required int initialValue,
    required Color color,
    required IconData icon,
    required ValueChanged<int> onSaved,
  }) async {
    final result = await Navigator.of(context).push<int>(
      PushPageRoute(
        page: EditGoalScreen(
          title: title,
          initialValue: initialValue,
          icon: icon,
          color: color,
        ),
      ),
    );

    if (result != null) {
      setState(() => onSaved(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final targets = user.goal.targets;

    // ---------------------------------------------------------
    // SCENARIO 1: ERROR (Retry Logic)
    // ---------------------------------------------------------
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isCalculating = true;
                  _error = null;
                });
                startComputation(); // Retry
              },
              child: const Text("Try Again"),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------------------------
    // SCENARIO 2: LOADING (Animation Sync)
    // ---------------------------------------------------------
    // Shows animation until BOTH (Data is Ready) AND (Timer is Done)
    if (_isCalculating || !_isAnimationDone) {
      return HealthPlanLoadingWidget(
        onFinished: () {
          if (mounted) {
            setState(() {
              _isAnimationDone = true;
            });
          }
        },
      );
    }

    // ---------------------------------------------------------
    // SCENARIO 3: SUCCESS (Dashboard)
    // ---------------------------------------------------------
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: DailyRecommendationDashboard(
                  macros: [
                    MacroData(
                      title: 'Calories',
                      value: targets?.calories?.toString() ?? '0',
                      progress: 0.5,
                      color: Theme.of(context).colorScheme.primary,
                      icon: Icons.local_fire_department,
                      onTap: () => _editValue(
                        title: 'Calories',
                        initialValue: targets?.calories ?? 0,
                        icon: Icons.local_fire_department,
                        color: Theme.of(context).colorScheme.primary,
                        onSaved: (v) {
                          ref
                              .read(userProvider.notifier)
                              .updateLocal(
                                (s) => s.copyWith(
                                  goal: s.goal.copyWith(
                                    targets: s.goal.targets.copyWith(
                                      calories: v,
                                    ),
                                  ),
                                ),
                              );
                        },
                      ),
                    ),
                    MacroData(
                      title: 'Carbs',
                      value: '${targets?.carbs ?? 0}g',
                      progress: 0.5, // Logic can be refined later
                      color: NutritionType.carbs.color,
                      icon: NutritionType.carbs.icon,
                      onTap: () => _editValue(
                        title: 'Carbs',
                        initialValue: targets?.carbs ?? 0,
                        icon: NutritionType.carbs.icon,
                        color: Theme.of(context).colorScheme.primary,
                        onSaved: (v) {
                          ref
                              .read(userProvider.notifier)
                              .updateLocal(
                                (s) => s.copyWith(
                              goal: s.goal.copyWith(
                                targets: s.goal.targets.copyWith(
                                  carbs: v,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    MacroData(
                      title: 'Protein',
                      value: '${targets?.protein ?? 0}g',
                      progress: 0.5,
                      color: NutritionType.protein.color,
                      icon: NutritionType.protein.icon,
                      onTap: () => _editValue(
                        title: 'Protein',
                        initialValue: targets?.protein ?? 0,
                        icon: NutritionType.protein.icon,
                        color: Theme.of(context).colorScheme.primary,
                        onSaved: (v) {
                          ref
                              .read(userProvider.notifier)
                              .updateLocal(
                                (s) => s.copyWith(
                              goal: s.goal.copyWith(
                                targets: s.goal.targets.copyWith(
                                  protein: v,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    MacroData(
                      title: 'Fats',
                      value: '${targets?.fats ?? 0}g',
                      progress: 0.5,
                      color: NutritionType.fats.color,
                      icon: NutritionType.fats.icon,
                      onTap: () => _editValue(
                        title: 'Fats',
                        initialValue: targets?.fats ?? 0,
                        icon: NutritionType.fats.icon,
                        color: Theme.of(context).colorScheme.primary,
                        onSaved: (v) {
                          ref
                              .read(userProvider.notifier)
                              .updateLocal(
                                (s) => s.copyWith(
                              goal: s.goal.copyWith(
                                targets: s.goal.targets.copyWith(
                                  fats: v,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  healthScoreProgress: 0.7,
                  healthScore: 5,
                  onHealthScoreTap: () {},
                ),
              ),
            ],
          ),
        ),
        ConfirmationButtonWidget(enabled: true, onConfirm: widget.nextPage),
      ],
    );
  }
}
