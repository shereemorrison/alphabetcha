import 'package:alphabetcha/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final player = gameProvider.currentPlayer;
        final room = gameProvider.currentRoom;

        return DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.games, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'AlphaBetcha',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (player != null) _buildPlayerInfo(player, room),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerInfo(player, room) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: player.color,
          radius: 16,
          child: Text(
            player.name[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (room != null)
                Text(
                  'Score: ${player.score} pts',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
