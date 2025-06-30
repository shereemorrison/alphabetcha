import 'package:flutter/material.dart';

class SliderSetting extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final Function(double) onChanged;
  final String displayValue;

  const SliderSetting({
    Key? key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.displayValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
