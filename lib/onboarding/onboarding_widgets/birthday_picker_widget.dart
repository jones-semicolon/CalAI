import 'package:flutter/material.dart';

class BirthdayPickerWidget extends StatefulWidget {
  final ValueChanged<DateTime>? onChanged;
  final DateTime? initialDate;

  const BirthdayPickerWidget({super.key, this.onChanged, this.initialDate});

  @override
  State<BirthdayPickerWidget> createState() => _BirthdayPickerWidgetState();
}

class _BirthdayPickerWidgetState extends State<BirthdayPickerWidget> {
  late int day;
  late int month;
  late int year;

  final days = List.generate(31, (i) => i + 1);
  final List<String> monthNames = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  late final List<int> years;

  late FixedExtentScrollController _dayCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _yearCtrl;

  static const double _itemHeight = 40;

  int _indexOf(List<int> list, int value) =>
      list.contains(value) ? list.indexOf(value) : 0;

  void _emit() {
    widget.onChanged?.call(DateTime(year, month, day));
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    years = [
      for (int y = 1950; y <= now.year; y++) y,
    ]; // Expanded range slightly

    final init = widget.initialDate ?? DateTime(2001, 1, 1);
    day = init.day;
    month = init.month;
    year = init.year;

    _dayCtrl = FixedExtentScrollController(initialItem: _indexOf(days, day));
    _monthCtrl = FixedExtentScrollController(
      initialItem: _indexOf(List.generate(12, (i) => i + 1), month),
    );
    _yearCtrl = FixedExtentScrollController(initialItem: _indexOf(years, year));
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pickerHeight = _itemHeight * 7;
    final pickerWidth = MediaQuery.of(context).size.width * 0.28;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _wheel(
          items: List.generate(12, (i) => i + 1),
          display: (i) => monthNames[i - 1],
          value: month,
          controller: _monthCtrl,
          width: pickerWidth,
          height: pickerHeight,
          onChanged: (v) {
            setState(() => month = v);
            _emit();
          },
        ),
        const SizedBox(width: 8),
        _wheel(
          items: days,
          display: (i) => i.toString().padLeft(2, '0'),
          value: day,
          controller: _dayCtrl,
          width: pickerWidth * 0.7,
          height: pickerHeight,
          onChanged: (v) {
            setState(() => day = v);
            _emit();
          },
        ),
        const SizedBox(width: 8),
        _wheel(
          items: years,
          display: (i) => i.toString(),
          value: year,
          controller: _yearCtrl,
          width: pickerWidth * 0.8,
          height: pickerHeight,
          onChanged: (v) {
            setState(() => year = v);
            _emit();
          },
        ),
      ],
    );
  }

  Widget _wheel({
    required List<int> items,
    required String Function(int) display,
    required int value,
    required FixedExtentScrollController controller,
    required double width,
    required double height,
    required ValueChanged<int> onChanged,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: _itemHeight,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryFixed,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: _itemHeight,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.007,
            onSelectedItemChanged: (index) => onChanged(items[index]),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (_, index) {
                final val = items[index];
                final selected = val == value;
                return Center(
                  child: Text(
                    display(val),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.outline,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
