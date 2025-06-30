import 'package:alphabetcha/models/game_models.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:alphabetcha/screens/final_results_screen.dart';
import 'package:alphabetcha/screens/game_play_screen.dart';
import 'package:flutter/material.dart';

class NextRoundButton extends StatelessWidget {
  final GameProvider gameProvider;
  final GameRoom room;

  const NextRoundButton({
    Key? key,
    required this.gameProvider,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastRound = room.currentRound >= room.settings.numberOfRounds;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleNext(context, isLastRound),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isLastRound ? 'View Final Results' : 'Next Round',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleNext(BuildContext context, bool isLastRound) {
    if (isLastRound) {
      gameProvider.endGame();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FinalResultsScreen()),
      );
    } else {
      gameProvider.nextRound();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GamePlayScreen()),
      );
    }
  }
}
