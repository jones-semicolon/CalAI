import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enums/user_enums.dart';
import '../../../onboarding/onboarding_widgets/dynamic_card.dart';
import '../../../providers/user_provider.dart';

class GenderPickerView extends ConsumerStatefulWidget {
  const GenderPickerView({super.key});

  @override
  ConsumerState<GenderPickerView> createState() => _GenderPickerViewState();
}

class _GenderPickerViewState extends ConsumerState<GenderPickerView> {
  bool isEnable = false;
  int? selectedIndex;

  final List<OptionCard> options = [
    OptionCard(title: 'Female', value: Gender.female),
    OptionCard(title: 'Male', value: Gender.male),
    OptionCard(title: 'Other', value: Gender.other),
  ];

  @override
  void initState() {
    super.initState();

    // Get saved gender from UserData
    final savedGender = ref.read(userProvider).profile.gender;

    // Find index of option matching saved gender
    final matchIndex = options.indexWhere((o) => o.value == savedGender);

    if (matchIndex != -1) {
      selectedIndex = matchIndex;
      isEnable = true; // enable continue because something is already selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          CustomAppBar(title: Text("Set Gender")),

          /// SCROLLABLE CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(options.length, (index) {
                  final item = options[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: OptionCard(
                      icon: item.icon,
                      title: item.title,
                      subtitle: item.subtitle,
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          isEnable = true;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          ConfirmationButtonWidget(onConfirm: () {
            if (selectedIndex == null) return;
            ref.read(userProvider.notifier).updateProfileField("gender", options[selectedIndex!].value);
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }
}
