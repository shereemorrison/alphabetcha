import 'package:flutter/material.dart';

import '../models/game_models.dart';

class GameInfoDialog {
  static void show(BuildContext context, GameRoom room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room ID: ${room.id}'),
            Text('Round: ${room.currentRound}/${room.settings.numberOfRounds}'),
            Text('Players: ${room.players.length}'),
            Text('Time per round: ${room.settings.timePerRound}s'),
            const SizedBox(height: 12),
            Text('Categories:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...room.settings.categories.map((cat) => Text('• $cat')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
