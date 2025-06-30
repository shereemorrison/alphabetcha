import 'package:flutter/material.dart';

class HomeMenuButtons extends StatelessWidget {
  final VoidCallback onCreateGame;
  final VoidCallback onJoinGame;
  final VoidCallback onQuickPlay;

  const HomeMenuButtons({
    Key? key,
    required this.onCreateGame,
    required this.onJoinGame,
    required this.onQuickPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMenuButton(
          context,
          'Create Game',
          'Start a new game with friends',
          Icons.add_circle,
          Color(0xFF483D8B),
          onCreateGame,
        ),
        const SizedBox(height: 16),
        _buildMenuButton(
          context,
          'Join Game',
          'Join an existing game room',
          Icons.group_add,
          Colors.deepPurple.shade200,
          onJoinGame,
        ),
        const SizedBox(height: 16),
        _buildMenuButton(
          context,
          'Quick Play',
          'Play against AI opponents',
          Icons.flash_on,
          Colors.indigo,
          onQuickPlay,
        ),
      ],
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
