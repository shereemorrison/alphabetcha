import 'package:alphabetcha/components/forms/create_game_forms.dart';
import 'package:alphabetcha/components/section_header.dart';
import 'package:alphabetcha/models/game_models.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:alphabetcha/screens/game_lobby_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGameScreen extends StatefulWidget {
  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _nameController = TextEditingController();
  int _numberOfRounds = 3;
  int _timePerRound = 120;
  int _computerPlayers = 0;
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    _selectedCategories =
        List.from(gameProvider.defaultCategories.take(4).map((c) => c.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Player Setup'),
              PlayerSetupForm(
                nameController: _nameController,
                computerPlayers: _computerPlayers,
                onComputerPlayersChanged: (value) =>
                    setState(() => _computerPlayers = value),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'Game Settings'),
              GameSettingsForm(
                numberOfRounds: _numberOfRounds,
                timePerRound: _timePerRound,
                onRoundsChanged: (value) =>
                    setState(() => _numberOfRounds = value),
                onTimeChanged: (value) => setState(() => _timePerRound = value),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'Categories'),
              CategoriesForm(
                selectedCategories: _selectedCategories,
                onCategoriesChanged: (categories) =>
                    setState(() => _selectedCategories = categories),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canCreateGame() ? _createGame : null,
                  child: Text('Create Game',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canCreateGame() {
    return _nameController.text.trim().isNotEmpty &&
        _selectedCategories.isNotEmpty;
  }

  void _createGame() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    gameProvider.createPlayer(_nameController.text.trim());
    gameProvider.createRoom(GameSettings(
      numberOfRounds: _numberOfRounds,
      timePerRound: _timePerRound,
      categories: _selectedCategories,
    ));

    if (_computerPlayers > 0) {
      gameProvider.addComputerPlayers(_computerPlayers);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GameLobbyScreen()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
