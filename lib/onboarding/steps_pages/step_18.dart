import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/edit_value_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/food_enums.dart';
import '../../pages/auth/auth.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/calibration_result/dashboard_widget.dart';
import '../onboarding_widgets/loading_widget/health_plan_loading_widget.dart';

class OnboardingStep18 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep18({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep18> createState() => OnboardingStep18State();
}

class OnboardingStep18State extends ConsumerState<OnboardingStep18> {
  bool _isCalculating = true; 
  bool _isAnimationDone = false;
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
      if (FirebaseAuth.instance.currentUser == null) {
        await AuthService.signInAsGuest();
      }
      await userNotifier.calculateGoals();

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
    required num initialValue,
    required Color color,
    required IconData icon,
    required ValueChanged<double> onSaved,
  }) async {
    final double? newValue = await showModalBottomSheet<double>(
      isScrollControlled: true,
      context: context,
      builder: (context) => EditModal(
        initialValue: initialValue.toDouble(),
        title: title,
        label: title,
        color: color,
        onDone: (val) {
          Navigator.pop(context, val);
        },
      ),
    );
    if (newValue != null && mounted) {
      onSaved(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final targets = user.goal.targets;

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
                startComputation(); 
              },
              child: const Text("Try Again"),
            ),
          ],
        ),
      );
    }

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
                      value: targets.calories.round().toString(),
                      progress: 0.5,
                      color: Theme.of(context).colorScheme.primary,
                      icon: Icons.local_fire_department,
                      onTap: () => _editValue(
                        title: 'Calories',
                        initialValue: targets.calories,
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
                      value: '${targets.carbs.round()}g',
                      progress: 0.5, // Logic can be refined later
                      color: NutritionType.carbs.color,
                      icon: NutritionType.carbs.icon,
                      onTap: () => _editValue(
                        title: 'Carbs',
                        initialValue: targets.carbs,
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
                      value: '${targets.protein.round()}g',
                      progress: 0.5,
                      color: NutritionType.protein.color,
                      icon: NutritionType.protein.icon,
                      onTap: () => _editValue(
                        title: 'Protein',
                        initialValue: targets.protein,
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
                      value: '${targets.fats.round()}g',
                      progress: 0.5,
                      color: NutritionType.fats.color,
                      icon: NutritionType.fats.icon,
                      onTap: () => _editValue(
                        title: 'Fats',
                        initialValue: targets.fats,
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
        ConfirmationButtonWidget(enabled: true, onConfirm: () {
          ref.read(userProvider.notifier).updateNutritionGoals(user.goal.targets);
          ref.read(userProvider.notifier).completeOnboarding();
          widget.nextPage();
        }),
      ],
    );
  }
}
