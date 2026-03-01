import 'package:calai/services/calai_firestore_service.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- IMPORTS ---
import 'package:calai/widgets/circle_back_button.dart';
import '../../../../api/exercise_api.dart';
import '../../../../enums/exercise_enums.dart';
import '../../../../models/exercise_model.dart';
import '../../../../providers/exercise_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../widgets/confirmation_button_widget.dart';

class RunExercisePage extends ConsumerStatefulWidget {
  const RunExercisePage({super.key});

  @override
  ConsumerState<RunExercisePage> createState() => _RunExercisePageState();
}

class _RunExercisePageState extends ConsumerState<RunExercisePage> {
  // --- DATA ---
  final List<Intensity> _intensityValues = [
    Intensity.high,
    Intensity.medium,
    Intensity.low,
  ];

  final List<int> _durations = [15, 30, 60, 90];

  // --- STATE ---
  double _sliderValue = 0.0;
  int _selectedDurationIndex = 0;
  late TextEditingController _durationController;

  final GlobalKey _barKey = GlobalKey();
  double _barHeight = 0;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(
      text: _durations[_selectedDurationIndex].toString(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
      _barKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _barHeight = renderBox.size.height;
        });
      }
    });
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _updateSlider(double localDy) {
    if (_barHeight == 0) return;
    double percent = localDy / _barHeight;
    percent = percent.clamp(0.0, 1.0);
    setState(() {
      _sliderValue = percent;
    });
  }

  int _getCurrentZoneIndex() {
    if (_sliderValue < 0.33) return 0;
    if (_sliderValue < 0.66) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final int activeIndex = _getCurrentZoneIndex();
    final l10n = context.l10n;
    final intensityOptions = [
      {
        'title': l10n.intensityHighLabel,
        'subtitle': l10n.runIntensityHighDescription,
      },
      {
        'title': l10n.intensityMediumLabel,
        'subtitle': l10n.runIntensityMediumDescription,
      },
      {
        'title': l10n.intensityLowLabel,
        'subtitle': l10n.runIntensityLowDescription,
      },
    ];
    ref.listen<ExerciseLogState>(exerciseLogProvider, (previous, next) {
      if (next.status == ExerciseLogStatus.loading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      } else if (next.status == ExerciseLogStatus.success) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading
        Navigator.pop(context); // Close Page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exerciseLoggedSuccessfully)),
        );
        ref.read(exerciseLogProvider.notifier).reset();
      } else if (next.status == ExerciseLogStatus.error) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.genericErrorMessage(next.errorMessage ?? ''))),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
          CustomAppBar(title: Row(
              mainAxisSize: MainAxisSize.min, // Keeps the row tight around the icon/text
              children: [
                Icon(Icons.directions_run, color: Theme.of(context).colorScheme.primary, size: 24),
                const SizedBox(width: 5),
                Text(
                  l10n.runTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            ),
            const SizedBox(height: 10),
            // --- SCROLLABLE CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.electric_bolt_outlined, size: 24),
                        SizedBox(width: 5),
                        Text(
                          l10n.setIntensityLabel,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- MAIN SELECTION CARD ---
                    Container(
                      height: 225,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          // TEXT LIST
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(intensityOptions.length, (index) {
                                final isSelected = activeIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sliderValue = index / 2.0;
                                    });
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 300),
                                          style: TextStyle(
                                            fontSize: isSelected ? 18 : 14,
                                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          child: Text(
                                            intensityOptions[index]['title'] as String,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 300),
                                          opacity: isSelected ? 1.0 : 0.5,
                                          child: Text(
                                            intensityOptions[index]['subtitle'] as String,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // SLIDER
                          GestureDetector(
                            onVerticalDragUpdate: (details) => _updateSlider(details.localPosition.dy),
                            onTapDown: (details) => _updateSlider(details.localPosition.dy),
                            child: Container(
                              key: _barKey,
                              color: Colors.transparent,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double h = constraints.maxHeight;
                                  double thumbY = _sliderValue * h;
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Container(
                                        width: 4,
                                        height: h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        top: thumbY,
                                        child: Container(
                                          width: 4,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: thumbY - 8,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- DURATION HEADER ---
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 24),
                        SizedBox(width: 8),
                        Text(
                          l10n.durationLabel,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- DURATION PILLS ---
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 5,
                        children: List.generate(_durations.length, (index) {
                          final isSelected = _selectedDurationIndex == index;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedDurationIndex = index;
                                _durationController.text = _durations[index].toString();
                              });
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondaryContainer,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : Colors.black26,
                                ),
                              ),
                              child: Text(
                                "${_durations[index]} ${l10n.minutesShortLabel}",
                                style: TextStyle(
                                  color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- INPUT FIELD ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: TextField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {
                            int? typedValue = int.tryParse(value);
                            if (typedValue != null && _durations.contains(typedValue)) {
                              _selectedDurationIndex = _durations.indexOf(typedValue);
                            } else {
                              _selectedDurationIndex = -1;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- FIXED BOTTOM BUTTON ---
            ConfirmationButtonWidget(onConfirm: _onLogEntry, text: l10n.addLabel)
          ],
        ),
      ),
    );
  }

  // --- INTEGRATED LOGIC ---
  void _onLogEntry() async {
    final String durationText = _durationController.text;
    if (durationText.isEmpty) return;

    final int duration = int.parse(durationText);
    if (duration <= 0) return;

    final activeIndex = _getCurrentZoneIndex();
    final Intensity intensityEnum = _intensityValues[activeIndex];

    // Call the provider
    await ref.read(exerciseLogProvider.notifier).logExercise(
      exerciseType: ExerciseType.run,
      intensity: intensityEnum,
      duration: duration,
    );
  }
}
