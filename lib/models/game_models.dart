import 'package:flutter/material.dart';

class Player {
  final String id;
  final String name;
  final Color color;
  int score;
  Map<String, String> currentAnswers;
  bool isReady;

  Player({
    required this.id,
    required this.name,
    required this.color,
    this.score = 0,
    Map<String, String>? currentAnswers,
    this.isReady = false,
  }) : currentAnswers = currentAnswers ?? {};

  Player copyWith({
    String? id,
    String? name,
    Color? color,
    int? score,
    Map<String, String>? currentAnswers,
    bool? isReady,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      score: score ?? this.score,
      currentAnswers: currentAnswers ?? this.currentAnswers,
      isReady: isReady ?? this.isReady,
    );
  }
}

class GameRoom {
  final String id;
  final String hostId;
  final List<Player> players;
  final GameSettings settings;
  GameState state;
  int currentRound;
  String? currentLetter;
  DateTime? roundStartTime;
  Map<String, List<PlayerAnswer>> roundAnswers;

  GameRoom({
    required this.id,
    required this.hostId,
    required this.players,
    required this.settings,
    this.state = GameState.waiting,
    this.currentRound = 0,
    this.currentLetter,
    this.roundStartTime,
    Map<String, List<PlayerAnswer>>? roundAnswers,
  }) : roundAnswers = roundAnswers ?? {};
}

class GameSettings {
  final int numberOfRounds;
  final int timePerRound; // in seconds
  final List<String> categories;

  GameSettings({
    this.numberOfRounds = 3,
    this.timePerRound = 120,
    required this.categories,
  });
}

class PlayerAnswer {
  final String playerId;
  final String playerName;
  final String answer;
  final bool isValidated;
  final int points;

  PlayerAnswer({
    required this.playerId,
    required this.playerName,
    required this.answer,
    this.isValidated = false,
    this.points = 0,
  });
}

enum GameState {
  waiting,
  starting,
  playing,
  roundEnd,
  gameEnd,
}

class Category {
  final String name;
  final String description;
  final IconData icon;

  Category({
    required this.name,
    required this.description,
    required this.icon,
  });
}
