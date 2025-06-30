import 'package:alphabetcha/components/buttons/home_menu_buttons.dart';
import 'package:alphabetcha/components/hamburger_menu.dart';
import 'package:alphabetcha/components/home_footer.dart';
import 'package:alphabetcha/components/home_header.dart';
import 'package:alphabetcha/models/game_models.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:alphabetcha/screens/create_game_screen.dart';
import 'package:alphabetcha/screens/game_lobby_screen.dart';
import 'package:alphabetcha/screens/join_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AlphaBetcha'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: HamburgerMenu(showGameControls: false),
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(flex: 2, child: HomeHeader()),
                Expanded(
                  flex: 3,
                  child: HomeMenuButtons(
                    onCreateGame: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateGameScreen()),
                    ),
                    onJoinGame: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoinGameScreen()),
                    ),
                    onQuickPlay: () => _startQuickPlay(context),
                  ),
                ),
                HomeFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startQuickPlay(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    // Create player
    gameProvider.createPlayer('You');

    // Create quick play settings
    final quickPlaySettings = GameSettings(
      numberOfRounds: 3,
      timePerRound: 90,
      categories: ['Actor/Actress', 'City', 'Animal', 'Food'],
    );

    // Create room
    gameProvider.createRoom(quickPlaySettings);

    // Add AI players
    gameProvider.addComputerPlayers(2);

    // Navigate to lobby
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameLobbyScreen()),
    );
  }
}
