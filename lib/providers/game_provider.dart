import 'dart:math';

import 'package:alphabetcha/models/game_models.dart';
import 'package:alphabetcha/services/ai_bot_service.dart';
import 'package:alphabetcha/services/ai_validation_service.dart';
import 'package:alphabetcha/utils/game_utils.dart';
import 'package:alphabetcha/utils/scoring_utils.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  GameRoom? _currentRoom;
  Player? _currentPlayer;
  final AIValidationService _aiService = AIValidationService();
  final AIBotService _botService = AIBotService();

  GameRoom? get currentRoom => _currentRoom;
  Player? get currentPlayer => _currentPlayer;

  final List<String> _letters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  final List<Category> _defaultCategories = [
    Category(
        name: 'Actor/Actress',
        description: 'Famous actors or actresses',
        icon: Icons.movie),
    Category(
        name: 'City',
        description: 'Cities around the world',
        icon: Icons.location_city),
    Category(
        name: 'Animal', description: 'Any animal species', icon: Icons.pets),
    Category(
        name: 'Food',
        description: 'Food items or dishes',
        icon: Icons.restaurant),
    Category(
        name: 'Country',
        description: 'Countries of the world',
        icon: Icons.flag),
    Category(
        name: 'Movie', description: 'Movie titles', icon: Icons.local_movies),
    Category(
        name: 'Brand',
        description: 'Company or product brands',
        icon: Icons.business),
    Category(name: 'Sport', description: 'Sports or games', icon: Icons.sports),
  ];

  List<Category> get defaultCategories => _defaultCategories;

  void createPlayer(String name) {
    _currentPlayer = GameUtils.createPlayerWithRandomColor(name);
    notifyListeners();
  }

  void createRoom(GameSettings settings) {
    if (_currentPlayer == null) return;
    _currentRoom = GameUtils.createGameRoom(_currentPlayer!, settings);
    notifyListeners();
  }

  void addComputerPlayers(int count) {
    if (_currentRoom == null || count <= 0) return;
    GameUtils.addComputerPlayersToRoom(_currentRoom!, count);
    notifyListeners();
  }

  void joinRoom(String roomId) {
    if (_currentPlayer == null) return;
    notifyListeners();
  }

  String generateRandomLetter() {
    return _letters[Random().nextInt(_letters.length)];
  }

  void startRound() {
    if (_currentRoom == null) return;

    _currentRoom!.currentLetter = generateRandomLetter();
    _currentRoom!.state = GameState.playing;
    _currentRoom!.roundStartTime = DateTime.now();
    _currentRoom!.currentRound++;

    GameUtils.resetPlayersForNewRound(_currentRoom!.players);
    _currentRoom!.roundAnswers.clear();
    _generateAIComputerAnswers();
    notifyListeners();
  }

  void _generateAIComputerAnswers() async {
    if (_currentRoom == null) return;

    final letter = _currentRoom!.currentLetter!;
    final categories = _currentRoom!.settings.categories;

    for (var player in _currentRoom!.players) {
      if (player.id.startsWith('bot_')) {
        _generateSingleBotAnswers(player, categories, letter);
      }
    }
  }

  void _generateSingleBotAnswers(
      Player botPlayer, List<String> categories, String letter) async {
    try {
      print('${botPlayer.name} is thinking...');
      final answers = await _botService.generateBotAnswers(
          categories, letter, botPlayer.name);
      botPlayer.currentAnswers = answers;

      final thinkingTime = Random().nextInt(3000) + 2000;
      Future.delayed(Duration(milliseconds: thinkingTime), () {
        if (_currentRoom?.state == GameState.playing) {
          botPlayer.isReady = true;
          print('${botPlayer.name} submitted ${answers.length} answers');
          notifyListeners();
          _checkAllPlayersReady();
        }
      });
    } catch (e) {
      print('Error generating answers for ${botPlayer.name}: $e');
      Future.delayed(Duration(seconds: 3), () {
        if (_currentRoom?.state == GameState.playing) {
          botPlayer.isReady = true;
          notifyListeners();
          _checkAllPlayersReady();
        }
      });
    }
  }

  void submitAnswer(String category, String answer) {
    if (_currentPlayer == null || _currentRoom == null) return;
    _currentPlayer!.currentAnswers[category] = answer.trim();
    notifyListeners();
  }

  void markPlayerReady() {
    if (_currentPlayer == null) return;
    _currentPlayer!.isReady = true;
    notifyListeners();
    _checkAllPlayersReady();
  }

  void _checkAllPlayersReady() {
    if (_currentRoom!.players.every((player) => player.isReady)) {
      _processRoundAnswers();
    }
  }

  Future<void> _processRoundAnswers() async {
    if (_currentRoom == null) return;
    print('Processing round answers...');

    Map<String, List<PlayerAnswer>> categoryAnswers = {};
    for (var category in _currentRoom!.settings.categories) {
      categoryAnswers[category] =
          GameUtils.collectAnswersForCategory(_currentRoom!.players, category);
    }

    for (var category in categoryAnswers.keys) {
      await ScoringUtils.validateAndScoreAnswers(
          category,
          categoryAnswers[category]!,
          _currentRoom!.currentLetter!,
          _aiService,
          _currentRoom!.players);
    }

    _currentRoom!.roundAnswers = categoryAnswers;
    _currentRoom!.state = GameState.roundEnd;
    print('Round processing complete, state: ${_currentRoom!.state}');
    notifyListeners();
  }

  void nextRound() {
    if (_currentRoom == null) return;

    if (_currentRoom!.currentRound >= _currentRoom!.settings.numberOfRounds) {
      _currentRoom!.state = GameState.gameEnd;
    } else {
      startRound();
    }
    notifyListeners();
  }

  void endGame() {
    if (_currentRoom == null) return;
    _currentRoom!.state = GameState.gameEnd;
    notifyListeners();
  }

  void resetGame() {
    if (_currentRoom == null) return;
    GameUtils.resetGameState(_currentRoom!);
    notifyListeners();
  }
}
