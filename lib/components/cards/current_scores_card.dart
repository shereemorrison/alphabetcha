import 'package:alphabetcha/models/game_models.dart';
import 'package:flutter/material.dart';

class CurrentScoresCard extends StatelessWidget {
  final List<Player> players;

  const CurrentScoresCard({Key? key, required this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = List<Player>.from(players)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Scores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...sortedPlayers.asMap().entries.map((entry) {
            final index = entry.key;
            final player = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: index == 0
                    ? Colors.amber.withOpacity(0.1)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: index == 0 ? Border.all(color: Colors.amber) : null,
              ),
              child: Row(
                children: [
                  Text(
                    '${index + 1}.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: player.color,
                    radius: 16,
                    child: Text(
                      player.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      player.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${player.score} pts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
