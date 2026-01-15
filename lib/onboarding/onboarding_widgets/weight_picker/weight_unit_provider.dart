import 'package:flutter_riverpod/legacy.dart';
import 'weight_enums.dart';
// used if pick kg or lbs in weight picker
final weightUnitProvider = StateProvider<WeightUnit>((ref) {
  return WeightUnit.kg;
});
