import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/flashcard.dart';

class AIService {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  final GenerativeModel _model;

  AIService()
      : _model = GenerativeModel(
    // 🌟 FIXED: Swapped out the old deprecated 1.5 variant for the current stable 2.5 version
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json', // Ensures strict structured output
    ),
  );

  Future<List<Map<String, String>>> generateFlashcards(String topic, {int count = 5}) async {
    final prompt = '''
    You are an expert educational assistant. Generate exactly $count flashcards for the topic or prompt: "$topic".
    You must output a raw valid JSON array containing objects with exactly two string keys: "question" and "answer".
    Do not wrap it in markdown block tags like ```json.
    
    Example format:
    [
      {"question": "What is Flutter?", "answer": "An open-source UI toolkit by Google for building cross-platform apps."}
    ]
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) throw Exception('Empty response from AI engine Layer.');

      // Safely parse out the raw structural JSON payload matrix
      final List<dynamic> decoded = jsonDecode(response.text!);

      return decoded.map((item) {
        return {
          'question': item['question']?.toString() ?? 'No question generated.',
          'answer': item['answer']?.toString() ?? 'No answer generated.',
        };
      }).toList();
    } catch (e) {
      throw Exception('AI Core failed to generate data: $e');
    }
  }
}