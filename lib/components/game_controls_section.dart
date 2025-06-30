import 'package:alphabetcha/models/menu_item.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:alphabetcha/utils/menu_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameControlsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final room = gameProvider.currentRoom;

        if (room == null) return SizedBox.shrink();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Game Controls',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            MenuItem(
              icon: Icons.restart_alt,
              title: 'Restart Game',
              onTap: () => MenuDialogs.showRestartConfirmation(context),
            ),
            MenuItem(
              icon: Icons.exit_to_app,
              title: 'End Game',
              onTap: () => MenuDialogs.showEndGameConfirmation(context),
              textColor: Colors.red[600],
            ),
          ],
        );
      },
    );
  }
}
