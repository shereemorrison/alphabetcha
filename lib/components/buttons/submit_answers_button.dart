import 'package:alphabetcha/models/game_models.dart';
import 'package:flutter/material.dart';

class SubmitAnswersButton extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final bool isSubmitted;
  final Player currentPlayer;
  final VoidCallback onSubmit;

  const SubmitAnswersButton({
    Key? key,
    required this.controllers,
    required this.isSubmitted,
    required this.currentPlayer,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasAnswers = controllers.values
        .any((controller) => controller.text.trim().isNotEmpty);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasAnswers && !isSubmitted && !currentPlayer.isReady
            ? onSubmit
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: currentPlayer.isReady
              ? Colors.green
              : Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: currentPlayer.isReady
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle),
                  const SizedBox(width: 8),
                  Text('Submitted! Waiting for others...'),
                ],
              )
            : Text(
                isSubmitted ? 'Submitting...' : 'Submit Answers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
