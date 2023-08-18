import 'package:flutter/material.dart';

import '../theme/colors.dart';

class HoursPanel extends StatelessWidget {
  final int startTime;
  final int endTime;
  const HoursPanel({super.key, required this.startTime, required this.endTime});

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
              ButtonHour(label: '${i.toString().padLeft(2, '0')}:00'),
          ],
        ),
      ],
    );
  }
}

class ButtonHour extends StatelessWidget {
  final String label;
  const ButtonHour({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: ColorsConstants.grey),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ColorsConstants.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
