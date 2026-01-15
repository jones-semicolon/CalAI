import 'package:flutter_riverpod/legacy.dart';

import '../../../data/health_data.dart';
import '../../../data/user_data.dart';
// used if pick kg or lbs in weight picker
final weightUnitProvider = StateProvider<WeightUnit>((ref) {
  return WeightUnit.kg;
});
