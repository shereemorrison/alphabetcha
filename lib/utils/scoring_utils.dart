import '../models/game_models.dart';
import '../services/ai_validation_service.dart';

class ScoringUtils {
  static Future<void> validateAndScoreAnswers(
    String category,
    List<PlayerAnswer> answers,
    String letter,
    AIValidationService aiService,
    List<Player> players,
  ) async {
    List<PlayerAnswer> validAnswers = [];

    // Validate answers using AI
    for (var answer in answers) {
      bool isValid =
          await aiService.validateAnswer(category, answer.answer, letter);

      if (isValid) {
        validAnswers.add(PlayerAnswer(
          playerId: answer.playerId,
          playerName: answer.playerName,
          answer: answer.answer,
          isValidated: true,
          points: 0,
        ));
      } else {
        print('Invalid answer: ${answer.answer} for category: $category');
      }
    }

    // Replace the original list with valid answers
    answers.clear();

    // Calculate scores based on uniqueness
    Map<String, List<PlayerAnswer>> answerGroups = {};

    for (var answer in validAnswers) {
      String normalizedAnswer = _normalizeAnswer(answer.answer);
      answerGroups[normalizedAnswer] ??= [];
      answerGroups[normalizedAnswer]!.add(answer);
    }

    // Assign points and update the answers list
    for (var group in answerGroups.values) {
      int points = _calculatePoints(group.length, validAnswers.length);

      for (var answer in group) {
        final updatedAnswer = PlayerAnswer(
          playerId: answer.playerId,
          playerName: answer.playerName,
          answer: answer.answer,
          isValidated: true,
          points: points,
        );
        answers.add(updatedAnswer);

        // Find player and add points
        var playerIndex = players.indexWhere((p) => p.id == answer.playerId);
        if (playerIndex != -1) {
          players[playerIndex].score += points;
        }
      }
    }
  }

  static String _normalizeAnswer(String answer) {
    return answer
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static int _calculatePoints(int groupSize, int totalAnswers) {
    if (groupSize == 1) {
      // Unique answer
      return totalAnswers == 1 ? 15 : 10;
    } else {
      // Shared answer
      return 5;
    }
  }
}
