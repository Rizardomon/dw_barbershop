// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class HoursPanel extends StatelessWidget {
  final int startTime;
  final int endTime;
  final ValueChanged<int> onHourPressed;
  final List<int>? enabledHours;

  const HoursPanel({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enabledHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = startTime; i <= endTime; i++)
              ButtonHour(
                label: '${i.toString().padLeft(2, '0')}:00',
                value: i,
                onPressed: onHourPressed,
                enabledHours: enabledHours,
              ),
          ],
        ),
      ],
    );
  }
}

class ButtonHour extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final List<int>? enabledHours;
  const ButtonHour({
    Key? key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.enabledHours,
  }) : super(key: key);

  @override
  State<ButtonHour> createState() => _ButtonHourState();
}

class _ButtonHourState extends State<ButtonHour> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brown : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brown : ColorsConstants.grey;

    final ButtonHour(:enabledHours, :value, :label, :onPressed) = widget;

    final disableHour = enabledHours != null && !enabledHours.contains(value);

    if (disableHour) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableHour
          ? null
          : () {
              onPressed(value);
              setState(() {
                selected = !selected;
              });
            },
      child: Container(
        width: 64,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonColor,
          border: Border.all(color: buttonBorderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
