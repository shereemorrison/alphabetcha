import 'package:alphabetcha/models/game_models.dart';
import 'package:flutter/material.dart';

class RoundSummaryCard extends StatelessWidget {
  final GameRoom room;

  const RoundSummaryCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Round ${room.currentRound} Complete!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Letter: ${room.currentLetter}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
