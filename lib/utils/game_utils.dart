import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_models.dart';

class GameUtils {
  static Player createPlayerWithRandomColor(String name) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo
    ];

    return Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      color: colors[Random().nextInt(colors.length)],
    );
  }

  static GameRoom createGameRoom(Player host, GameSettings settings) {
    return GameRoom(
      id: _generateRoomId(),
      hostId: host.id,
      players: [host],
      settings: settings,
    );
  }

  static void addComputerPlayersToRoom(GameRoom room, int count) {
    final computerNames = [
      'AI Alice',
      'Bot Bob',
      'Cyber Charlie',
      'Digital Diana',
      'Electric Eve'
    ];
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink
    ];

    for (int i = 0; i < count && i < computerNames.length; i++) {
      final botPlayer = Player(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch + i}',
        name: computerNames[i],
        color: colors[(i + 1) % colors.length],
      );
      room.players.add(botPlayer);
    }
  }

  static void resetPlayersForNewRound(List<Player> players) {
    for (var player in players) {
      player.currentAnswers = {};
      player.isReady = false;
    }
  }

  static List<PlayerAnswer> collectAnswersForCategory(
      List<Player> players, String category) {
    List<PlayerAnswer> answers = [];

    for (var player in players) {
      String? answer = player.currentAnswers[category];
      if (answer != null && answer.isNotEmpty) {
        answers.add(PlayerAnswer(
          playerId: player.id,
          playerName: player.name,
          answer: answer,
        ));
      }
    }

    return answers;
  }

  static void resetGameState(GameRoom room) {
    room.currentRound = 0;
    room.state = GameState.waiting;
    room.currentLetter = null;
    room.roundAnswers.clear();

    for (var player in room.players) {
      player.score = 0;
      player.currentAnswers = {};
      player.isReady = false;
    }
  }

  static String _generateRoomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
