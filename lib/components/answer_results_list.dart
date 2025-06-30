import 'package:flutter/material.dart';

import '../models/game_models.dart';

class AnswerResultsList extends StatelessWidget {
  final GameRoom room;

  const AnswerResultsList({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (room.roundAnswers.isEmpty) {
      return Center(
        child: Text('No answers to display'),
      );
    }

    return ListView.builder(
      itemCount: room.settings.categories.length,
      itemBuilder: (context, index) {
        final category = room.settings.categories[index];
        final answers = room.roundAnswers[category] ?? [];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
                category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              if (answers.isEmpty)
                Text(
                  'No valid answers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                ...answers
                    .map((answer) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${answer.playerName}: ${answer.answer}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getPointsColor(answer.points)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${answer.points} pts',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getPointsColor(answer.points),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
            ],
          ),
        );
      },
    );
  }

  Color _getPointsColor(int points) {
    switch (points) {
      case 15:
        return Colors.purple;
      case 10:
        return Colors.green;
      case 5:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
