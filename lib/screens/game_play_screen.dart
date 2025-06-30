import 'dart:async';

import 'package:alphabetcha/components/buttons/submit_answers_button.dart';
import 'package:alphabetcha/components/cards/game_letter_card.dart';
import 'package:alphabetcha/components/cards/game_timer_card.dart';
import 'package:alphabetcha/components/categories_input.dart';
import 'package:alphabetcha/components/hamburger_menu.dart';
import 'package:alphabetcha/models/game_models.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:alphabetcha/screens/round_results_screen.dart';
import 'package:alphabetcha/utils/game_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamePlayScreen extends StatefulWidget {
  @override
  _GamePlayScreenState createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  Map<String, TextEditingController> _controllers = {};
  bool _isSubmitted = false;
  Timer? _timer;
  int _timeRemaining = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startTimer();
  }

  void _initializeControllers() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final categories = gameProvider.currentRoom?.settings.categories ?? [];

    for (String category in categories) {
      _controllers[category] = TextEditingController();
    }

    _timeRemaining = gameProvider.currentRoom?.settings.timePerRound ?? 120;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer?.cancel();
          if (!_isSubmitted) {
            _submitAnswers();
          }
        }
      });
    });
  }

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

        // Navigate to results when round ends
        if (room.state == GameState.roundEnd) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RoundResultsScreen()),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Round ${room.currentRound}/${room.settings.numberOfRounds}'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () => GameInfoDialog.show(context, room),
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
                  GameLetterCard(letter: room.currentLetter ?? 'A'),
                  const SizedBox(height: 16),
                  GameTimerCard(timeRemaining: _timeRemaining),
                  const SizedBox(height: 24),
                  Expanded(
                    child: CategoriesInput(
                      categories: room.settings.categories,
                      controllers: _controllers,
                      isSubmitted: _isSubmitted,
                      onAnswerChanged: _onAnswerChanged,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SubmitAnswersButton(
                    controllers: _controllers,
                    isSubmitted: _isSubmitted,
                    currentPlayer: currentPlayer,
                    onSubmit: _submitAnswers,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onAnswerChanged(String category, String value) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.submitAnswer(category, value);
  }

  void _submitAnswers() {
    setState(() => _isSubmitted = true);
    _timer?.cancel();

    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    _controllers.forEach((category, controller) {
      if (controller.text.trim().isNotEmpty) {
        gameProvider.submitAnswer(category, controller.text.trim());
      }
    });

    gameProvider.markPlayerReady();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
