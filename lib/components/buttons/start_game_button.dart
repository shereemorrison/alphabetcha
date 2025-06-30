import 'package:flutter/material.dart';

class StartGameButton extends StatelessWidget {
  final bool canStart;
  final VoidCallback onStart;

  const StartGameButton({
    Key? key,
    required this.canStart,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canStart ? onStart : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          canStart ? 'Start Game' : 'Waiting for host...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
