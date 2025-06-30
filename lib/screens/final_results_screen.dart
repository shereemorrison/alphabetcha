import 'package:alphabetcha/components/buttons/results_action_buttons.dart';
import 'package:alphabetcha/components/cards/winner_card.dart';
import 'package:alphabetcha/components/final_rankings.dart';
import 'package:alphabetcha/models/game_models.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinalResultsScreen extends StatelessWidget {
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

        final sortedPlayers = List<Player>.from(room.players)
          ..sort((a, b) => b.score.compareTo(a.score));

        return Scaffold(
          appBar: AppBar(
            title: Text('Final Results'),
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
                  WinnerCard(winner: sortedPlayers.first),
                  const SizedBox(height: 24),
                  Expanded(
                    child: FinalRankings(players: sortedPlayers),
                  ),
                  const SizedBox(height: 24),
                  ResultsActionButtons(gameProvider: gameProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
