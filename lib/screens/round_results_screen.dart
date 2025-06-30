import 'package:alphabetcha/components/answer_results_list.dart';
import 'package:alphabetcha/components/buttons/next_round_button.dart';
import 'package:alphabetcha/components/cards/current_scores_card.dart';
import 'package:alphabetcha/components/cards/round_summary_card.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final room = gameProvider.currentRoom;

        if (room == null) {
          return Scaffold(
            body: Center(child: Text('Error: No game data found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Round ${room.currentRound} Results'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  RoundSummaryCard(room: room),
                  const SizedBox(height: 24),
                  CurrentScoresCard(players: room.players),
                  const SizedBox(height: 24),
                  Expanded(
                    child: AnswerResultsList(room: room),
                  ),
                  const SizedBox(height: 24),
                  NextRoundButton(gameProvider: gameProvider, room: room),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
