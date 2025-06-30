import 'package:alphabetcha/components/cards/game_card.dart';
import 'package:alphabetcha/components/counter_control.dart';
import 'package:flutter/material.dart';

class PlayerSetupForm extends StatelessWidget {
  final TextEditingController nameController;
  final int computerPlayers;
  final Function(int) onComputerPlayersChanged;

  const PlayerSetupForm({
    Key? key,
    required this.nameController,
    required this.computerPlayers,
    required this.onComputerPlayersChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          Text('Computer Players',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text('Add AI opponents: $computerPlayers')),
              CounterControl(
                value: computerPlayers,
                min: 0,
                max: 4,
                onChanged: onComputerPlayersChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
