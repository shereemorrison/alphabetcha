import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../screens/final_results_screen.dart';
import '../screens/home_screen.dart';

class MenuDialogs {
  static void showRestartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restart Game'),
          content: Text(
              'Are you sure you want to restart the current game? All progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<GameProvider>(context, listen: false).resetGame();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Game restarted')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  static void showEndGameConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('End Game'),
          content: Text(
              'Are you sure you want to end the current game? Final scores will be calculated.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final gameProvider =
                    Provider.of<GameProvider>(context, listen: false);
                gameProvider.endGame();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FinalResultsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('End Game'),
            ),
          ],
        );
      },
    );
  }

  static void showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How to Play'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🎯 Objective',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                    'Score points by providing valid answers for each category that start with the given letter.'),
                const SizedBox(height: 12),
                Text('⚡ Scoring',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('• Unique answer: 10-15 points'),
                Text('• Shared answer: 5 points'),
                Text('• Invalid answer: 0 points'),
                const SizedBox(height: 12),
                Text('⏱️ Time Limit',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                    'Each round has a time limit. Submit before time runs out!'),
                const SizedBox(height: 12),
                Text('🏆 Winning',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Player with the most points after all rounds wins!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  static void showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Alphabetcha'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Alphabetcha',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Version 1.0.0'),
              const SizedBox(height: 12),
              Text(
                  'A fast-paced word game where creativity meets competition!'),
              const SizedBox(height: 12),
              Text('Features:'),
              Text('• AI-powered answer validation'),
              Text('• Smart computer opponents'),
              Text('• Multiple categories'),
              Text('• Customizable game settings'),
              const SizedBox(height: 12),
              Text('Made using Flutter',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  static void goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }
}
