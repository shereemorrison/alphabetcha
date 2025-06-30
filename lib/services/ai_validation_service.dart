import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIValidationService {
  // Get API key from environment variables
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<bool> validateAnswer(
      String category, String answer, String letter) async {
    // If no API key is provided, use fallback validation
    if (_apiKey.isEmpty) {
      print('No API key provided, using fallback validation');
      return _fallbackValidation(category, answer, letter);
    }

    try {
      final prompt = '''
You are validating answers for a word game. 
Category: $category
Answer: $answer
Required starting letter: $letter

Rules:
1. The answer must start with the letter "$letter" (case insensitive)
2. The answer must be a valid example of the category "$category"
3. Be VERY lenient with spelling variations, typos, and common abbreviations
4. Accept both singular and plural forms where appropriate
5. Accept common misspellings if the intent is clear
6. Accept shortened versions (e.g., "NYC" for "New York City")

Examples of what to accept:
- "Arnie" for Arnold Schwarzenegger (Actor)
- "NYC" for New York City (City)
- "McDonalds" without apostrophe (Brand)
- Minor spelling errors like "Chigago" for Chicago

Respond with only "true" if the answer is valid, or "false" if invalid.
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 10,
          'temperature': 0.1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['choices'][0]['message']['content']
            .toString()
            .toLowerCase()
            .trim();
        return result == 'true';
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        // Fallback validation
        return _fallbackValidation(category, answer, letter);
      }
    } catch (e) {
      print('Validation error: $e');
      // Fallback validation
      return _fallbackValidation(category, answer, letter);
    }
  }

  bool _fallbackValidation(String category, String answer, String letter) {
    // Fallback validation with spelling tolerance
    final cleanAnswer = answer.trim().toLowerCase();
    final cleanLetter = letter.toLowerCase();

    // Check if answer starts with the correct letter
    if (!cleanAnswer.startsWith(cleanLetter)) {
      return false;
    }

    // Check minimum length (at least 2 characters)
    if (cleanAnswer.length < 2) {
      return false;
    }

    // Very lenient validation - just check basic format
    // Allow letters, numbers, spaces, hyphens, periods, ampersands, exclamation marks
    final basicPattern = RegExp(r'^[a-z0-9][a-z0-9\s\-\.\&\!]*$');

    if (!basicPattern.hasMatch(cleanAnswer)) {
      return false;
    }

    // Category-specific length checks (very lenient)
    switch (category.toLowerCase()) {
      case 'actor/actress':
      case 'actor':
      case 'actress':
        return cleanAnswer.length >= 2; // Very lenient for names

      case 'city':
      case 'country':
        return cleanAnswer.length >= 2; // Very lenient for places

      case 'animal':
        return cleanAnswer.length >= 2; // Very lenient for animals

      case 'food':
        return cleanAnswer.length >= 2; // Very lenient for food

      case 'movie':
        return cleanAnswer.length >=
            1; // Very lenient for movies (could be "A")

      case 'brand':
        return cleanAnswer.length >= 1; // Very lenient for brands

      case 'sport':
        return cleanAnswer.length >= 2; // Very lenient for sports

      default:
        return cleanAnswer.length >= 2; // Generic lenient validation
    }
  }
}
