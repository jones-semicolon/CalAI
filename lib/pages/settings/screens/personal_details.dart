import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting

// Keep your existing imports...
import '../../../providers/user_provider.dart';
import '../../../enums/user_enums.dart';
import '../../../widgets/edit_value_view.dart';
import '../../../widgets/header_widget.dart';
import '../../progress/screens/goal_picker_view.dart';
import '../../progress/screens/weight_picker_view.dart';
import 'date_picker_view.dart';
import 'gender_picker_view.dart';
import 'height_picker_view.dart';

class PersonalDetailsPage extends ConsumerWidget { // Changed to ConsumerWidget
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef
    // Watch the user provider for real-time updates
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final target = user.goal.targets;
    final unitSystem = user.settings.measurementUnit;

    final displayWeight = unitSystem?.metricToDisplay(user.body.currentWeight) ?? user.body.currentWeight;
    final displayHeight = unitSystem?.heightToDisplay(user.body.height) ?? user.body.height;
    final displayGoalWeight = unitSystem?.metricToDisplay(target.weightGoal) ?? target.weightGoal;

    final String dobStr = user.profile.birthDate != null
        ? DateFormat('MMM dd, yyyy').format(user.profile.birthDate!)
        : 'Not set';

    final String? genderStr = user.profile.gender?.label;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(title: const Text("Personal details")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildCard(
                    context: context,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Goal Weight', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text('${displayGoalWeight.round()} ${unitSystem?.weightLabel ?? MeasurementUnit.metric.weightLabel}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalPickerView())),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text('Change Goal', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    context: context,
                    child: Column(
                      children: [
                        _buildListTile('Current Weight', '${displayWeight.round()} ${unitSystem?.weightLabel ?? MeasurementUnit.metric.weightLabel}',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeightPickerView()))),
                        _buildDivider(),
                        _buildListTile('Height', '${displayHeight.round()} ${unitSystem?.heightLabel ?? MeasurementUnit.metric.heightLabel}',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HeightPickerView()))),
                        _buildDivider(),
                        _buildListTile('Date of birth', dobStr,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DatePickerView()))),
                        _buildDivider(),
                        _buildListTile('Gender', genderStr ?? 'Male',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GenderPickerView()))),
                        _buildDivider(),
                        _buildListTile(
                          'Daily Step Goal',
                          '${target.steps.round()} steps',
                          isLast: true,
                          onTap: () => _showEdit(
                            context,
                            "Step Goal",
                            target.steps.toDouble(),
                            Theme.of(context).colorScheme.primary,
                                (val) {
                              userNotifier.updateLocal((s) => s.copyWith(
                                goal: s.goal.copyWith(
                                  targets: s.goal.targets.copyWith(steps: val),
                              )));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showEdit(
      BuildContext context,
      String title,
      double val,
      Color color,
      Function(double) onSaved,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => EditModal(
        initialValue: val,
        title: title,
        label: title,
        color: color,
        onDone: (newVal) {
          onSaved(newVal);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildCard({required BuildContext context, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildListTile(String title, String trailing, {VoidCallback? onTap, bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(trailing, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          // Wrapping the Icon in a gesture handler
          GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200);
  }
}