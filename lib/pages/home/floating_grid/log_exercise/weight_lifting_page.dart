import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- IMPORTS ---
// Update these paths to match your project structure
import 'package:calai/widgets/circle_back_button.dart';
import '../../../../api/exercise_api.dart';
import '../../../../data/global_data.dart';
import '../../../../data/user_data.dart';

class WeightLiftingPage extends ConsumerStatefulWidget {
  const WeightLiftingPage({super.key});

  @override
  ConsumerState<WeightLiftingPage> createState() => _WeightLiftingPageState();
}

class _WeightLiftingPageState extends ConsumerState<WeightLiftingPage> {
  // --- DATA ---
  // Updated to use dynamic values so we can store the Enum
  final List<Map<String, dynamic>> _intensityOptions = [
    {
      'title': 'High',
      'subtitle': 'Training to failure, breathing heavily',
      'value': Intensity.high,
    },
    {
      'title': 'Medium',
      'subtitle': 'Breaking a sweat, many reps',
      'value': Intensity.medium,
    },
    {
      'title': 'Low',
      'subtitle': 'Not breaking a sweat, giving little effort',
      'value': Intensity.low,
    },
  ];

  // Changed to integers for logic
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

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   leading: const Padding(
      //     padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
      //     child: CircleBackButton(),
      //   ),
      //   title: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: const [
      //       Icon(Icons.fitness_center, color: Colors.black, size: 24),
      //       SizedBox(width: 5),
      //       Text(
      //         'Weight Lifting',
      //         style: TextStyle(
      //           color: Colors.black,
      //           fontWeight: FontWeight.bold,
      //           fontSize: 18,
      //         ),
      //       ),
      //     ],
      //   ),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 10),
            // --- SCROLLABLE CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.electric_bolt_outlined, size: 24),
                        SizedBox(width: 5),
                        Text(
                          'Set Intensity',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- MAIN SELECTION CARD ---
                    Container(
                      height: 250,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          // TEXT LIST
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(_intensityOptions.length, (index) {
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
                                            fontSize: isSelected ? 24 : 16,
                                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          child: Text(
                                            _intensityOptions[index]['title'] as String,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 300),
                                          opacity: isSelected ? 1.0 : 0.5,
                                          child: Text(
                                            _intensityOptions[index]['subtitle'] as String,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
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
                      children: const [
                        Icon(Icons.timer_outlined, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Duration',
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
                                color: isSelected ? const Color(0xFF1A1C29) : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : Colors.black26,
                                ),
                              ),
                              child: Text(
                                "${_durations[index]} mins",
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
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
                        color: const Color(0xFFF2F4F8),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _onLogEntry, // Calls logic below
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1C29),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        alignment: Alignment.center, // This ensures the title stays dead-center
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleBackButton(onTap: () => Navigator.pop(context)),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min, // Keeps the row tight around the icon/text
            children: [
              Icon(Icons.fitness_center, color: Colors.black, size: 24),
              SizedBox(width: 5),
              Text(
                "Weight lifting",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- LOGIC ---
  Future<void> _onLogEntry() async {
    // 1. Validate Input
    if (_durationController.text.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please enter a duration')),
      // );
      return;
    }

    final int duration = int.parse(_durationController.text);
    if (duration <= 0) return;

    // 2. Prepare Data
    final activeIndex = _getCurrentZoneIndex();
    final Intensity intensityEnum = _intensityOptions[activeIndex]['value'] as Intensity;
    final String intensityTitle = intensityEnum.label;

    final user = ref.read(userProvider);
    final double weightKg = user.weight > 0 ? user.weight : 70.0;

    // 3. Show Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 4. API CALL
      final apiResponse = await ExerciseApi().getBurnedCalories(
        weightKg: weightKg,
        exerciseType: ExerciseType.weightLifting.label,
        intensity: intensityTitle,
        durationMins: duration,
      );

      debugPrint("API Response: $apiResponse");

      // 5. EXTRACT DATA
      // Handle cases where 'data' might be null or format is different
      final dynamic rawCalories = apiResponse['data']?['calories_burned'];
      final double burnedCalories = (rawCalories is num) ? rawCalories.toDouble() : 0.0;

      // 6. FIREBASE LOG
      await ref.read(globalDataProvider.notifier).logExerciseEntry(
        burnedCalories: burnedCalories,
        weightKg: weightKg,
        exerciseType: ExerciseType.weightLifting.label,
        intensity: intensityTitle,
        durationMins: duration,
      );

      // 7. Success & Close
      if (mounted) {
        // Close the Loading Dialog
        Navigator.of(context, rootNavigator: true).pop();

        // Close the Run Page
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged run: ${burnedCalories.toInt()} kcal burned!')),
        );
      }
    } catch (e) {
      debugPrint("Logging Error: $e");
      if (mounted) {
        // Close the Loading Dialog only
        Navigator.of(context, rootNavigator: true).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}