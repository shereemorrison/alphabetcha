import 'package:alphabetcha/components/cards/game_card.dart';
import 'package:alphabetcha/components/slider_setting.dart';
import 'package:flutter/material.dart';

class GameSettingsForm extends StatelessWidget {
  final int numberOfRounds;
  final int timePerRound;
  final Function(int) onRoundsChanged;
  final Function(int) onTimeChanged;

  const GameSettingsForm({
    Key? key,
    required this.numberOfRounds,
    required this.timePerRound,
    required this.onRoundsChanged,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SliderSetting(
            title: 'Number of Rounds',
            value: numberOfRounds.toDouble(),
            min: 1,
            max: 10,
            onChanged: (value) => onRoundsChanged(value.round()),
            displayValue: '$numberOfRounds rounds',
          ),
          const SizedBox(height: 20),
          SliderSetting(
            title: 'Time per Round',
            value: timePerRound.toDouble(),
            min: 30,
            max: 300,
            onChanged: (value) => onTimeChanged(value.round()),
            displayValue:
                '${timePerRound ~/ 60}:${(timePerRound % 60).toString().padLeft(2, '0')}',
          ),
        ],
      ),
    );
  }
}
