import 'package:alphabetcha/models/game_models.dart';
import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final Player player;
  final double radius;
  final bool showStatus;

  const PlayerAvatar({
    Key? key,
    required this.player,
    this.radius = 20,
    this.showStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBot = player.id.startsWith('bot_');

    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: player.color,
          radius: radius,
          child: isBot
              ? Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: radius * 0.8,
                )
              : Text(
                  player.name[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: radius * 0.6,
                  ),
                ),
        ),
        if (showStatus && player.isReady)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.6,
              height: radius * 0.6,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: radius * 0.3,
              ),
            ),
          ),
      ],
    );
  }
}
