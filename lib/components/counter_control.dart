import 'package:flutter/material.dart';

class CounterControl extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const CounterControl({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: Icon(Icons.remove_circle),
          color: Theme.of(context).colorScheme.primary,
        ),
        Text('$value',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: Icon(Icons.add_circle),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
