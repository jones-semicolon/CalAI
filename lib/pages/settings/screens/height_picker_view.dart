import 'package:calai/providers/user_provider.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/calai_firestore_service.dart';
import '../../../widgets/header_widget.dart';
import '../../../widgets/profile_widgets/height_picker.dart';

class HeightPickerView extends ConsumerStatefulWidget {
  const HeightPickerView({super.key});

  @override
  ConsumerState<HeightPickerView> createState() =>
      _HeightPickerView();
}

class _HeightPickerView extends ConsumerState<HeightPickerView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late double heightValue;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          CustomAppBar(title: Text(context.l10n.setHeightTitle)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HeightPicker(isMetric: true, initialHeightCm: ref.read(userProvider).body.height, onHeightChanged: (v) {heightValue = v;}),
              ],
            ),
          ),
          ConfirmationButtonWidget(onConfirm: (){
            ref.read(userProvider.notifier).updateUserBodyField('height', heightValue);
            Navigator.pop(context);
          })
        ],
      ),
    );
  }
}
