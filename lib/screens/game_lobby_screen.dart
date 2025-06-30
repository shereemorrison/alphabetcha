import 'package:alphabetcha/components/buttons/start_game_button.dart';
import 'package:alphabetcha/components/cards/lobby_players_card.dart';
import 'package:alphabetcha/components/cards/lobby_settings_card.dart';
import 'package:alphabetcha/components/cards/room_info_card.dart';
import 'package:alphabetcha/components/hamburger_menu.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:alphabetcha/screens/game_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameLobbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final room = gameProvider.currentRoom;
        final currentPlayer = gameProvider.currentPlayer;

        if (room == null || currentPlayer == null) {
          return Scaffold(
            body: Center(child: Text('Error: No game data found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Game Lobby'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _shareRoomCode(context, room.id),
              ),
            ],
          ),
          drawer: HamburgerMenu(showGameControls: true),
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
                  RoomInfoCard(roomId: room.id),
                  const SizedBox(height: 24),
                  Expanded(child: LobbyPlayersCard(players: room.players)),
                  const SizedBox(height: 24),
                  LobbySettingsCard(settings: room.settings),
                  const SizedBox(height: 24),
                  StartGameButton(
                    canStart: room.players.length >= 1 &&
                        currentPlayer.id == room.hostId,
                    onStart: () => _startGame(context, gameProvider),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _shareRoomCode(BuildContext context, String roomId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Room Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share this code with friends:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                roomId,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
            ),
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

  void _startGame(BuildContext context, GameProvider gameProvider) {
    gameProvider.startRound();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GamePlayScreen()),
    );
  }
}
