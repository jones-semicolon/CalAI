import 'package:calai/providers/user_provider.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/profile_widgets/birthday_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/header_widget.dart';

class DatePickerView extends ConsumerStatefulWidget {
  const DatePickerView({super.key});

  @override
  ConsumerState<DatePickerView> createState() =>
      _DatePickerViewState();
}

class _DatePickerViewState extends ConsumerState<DatePickerView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late DateTime selectedDate;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          CustomAppBar(title: Text("Set Birthday")),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BirthdayPickerWidget(initialDate: ref.read(userProvider).profile.birthDate, onChanged: (d) => selectedDate = d,)
              ],
            ),
          ),
          ConfirmationButtonWidget(onConfirm: (){
            ref.read(userProvider.notifier).updateProfileField("birthDate", selectedDate);
            Navigator.pop(context);
          })
        ],
      ),
    );
  }
}