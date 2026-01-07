import 'package:flutter/material.dart';
import 'progress_data_provider.dart';

/// A developer-friendly class to encapsulate all BMI calculation and interpretation logic.
///
/// This class takes raw BMI data and provides clean, ready-to-use outputs
/// like labels, colors, and indicator values for the UI, handling the logic
/// for both adults and children.
class BmiCalculator {
  final double bmi;
  final int age;
  final Sex sex;

  BmiCalculator({
    required this.bmi,
    required this.age,
    required this.sex,
  });

  // --- Color Constants --- //
  static const Color blue = Color.fromARGB(255, 4, 148, 208);
  static const Color green = Color.fromARGB(255, 54, 184, 58);
  static const Color orange = Color.fromARGB(255, 242, 184, 74);
  static const Color red = Color.fromARGB(255, 234, 89, 86);

  // --- Core Logic --- //

  /// Determines if the user is considered an adult for BMI calculation purposes.
  bool get isAdult => age >= 18;

  /// Returns the appropriate BMI category label (e.g., "Healthy", "Overweight").
  String get label => isAdult ? _adultLabel : _childLabel;

  /// Returns the color corresponding to the BMI category.
  Color get color => isAdult ? _adultColor : _childColor;

  /// Calculates the position of the indicator on the progress bar (from 0.0 to 1.0).
  double get indicatorValue {
    if (isAdult) {
      const minBmi = 14.0;
      const maxBmi = 40.0;
      // Normalize the BMI value to fit within the 0-1 range of the progress bar.
      return ((bmi.clamp(minBmi, maxBmi) - minBmi) / (maxBmi - minBmi));
    } else {
      return _childPercentile / 100;
    }
  }

  // --- Private Helpers for Adult Calculations --- //

  String get _adultLabel {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Healthy';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color get _adultColor {
    if (bmi < 18.5) return blue;
    if (bmi < 25) return green;
    if (bmi < 30) return orange;
    return red;
  }

  // --- Private Helpers for Child Calculations --- //
  // NOTE: This is a simplified placeholder. In a real app, this would
  // use official CDC/WHO data tables for accurate percentile calculations.
  double get _childPercentile {
    if (bmi < 14) return 3;
    if (bmi < 17) return 25;
    if (bmi < 20) return 50;
    if (bmi < 23) return 85;
    return 95;
  }

  String get _childLabel {
    if (_childPercentile < 5) return 'Underweight';
    if (_childPercentile < 85) return 'Healthy';
    if (_childPercentile < 95) return 'Overweight';
    return 'Obese';
  }

  Color get _childColor {
    if (_childPercentile < 5) return blue;
    if (_childPercentile < 85) return green;
    if (_childPercentile < 95) return orange;
    return red;
  }
}
