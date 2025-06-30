import 'package:alphabetcha/components/hamburger_menu.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinGameScreen extends StatefulWidget {
  @override
  _JoinGameScreenState createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final _nameController = TextEditingController();
  final _roomCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Game'),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    Icon(
                      Icons.group_add,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Join a Game',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your details to join an existing game',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Input Form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Your Name',
                              hintText: 'Enter your name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _roomCodeController,
                            decoration: InputDecoration(
                              labelText: 'Room Code',
                              hintText: 'Enter 6-digit room code',
                              prefixIcon: Icon(Icons.key),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Join Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canJoinGame() ? _joinGame : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Join Game',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canJoinGame() {
    return _nameController.text.trim().isNotEmpty &&
        _roomCodeController.text.trim().length == 6;
  }

  void _joinGame() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    // Create player
    gameProvider.createPlayer(_nameController.text.trim());

    // Join room - TODO: Implement room joining logic
    gameProvider.joinRoom(_roomCodeController.text.trim().toUpperCase());

    // For demo, show a message and navigate back - TODO: Replace with actual navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Joining room ${_roomCodeController.text.trim().toUpperCase()}...'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => GameLobbyScreen()),
    // );

    // For demo, go back to home
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomCodeController.dispose();
    super.dispose();
  }
}
