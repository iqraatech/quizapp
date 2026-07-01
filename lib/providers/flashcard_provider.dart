import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/storage_service.dart';
import '../services/ai_service.dart';

class FlashcardProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final AIService _aiService = AIService();
  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  List<Flashcard> _flashcards = [];
  List<Flashcard> _filteredCards = [];
  int _currentIndex = 0;
  String _searchQuery = '';

  List<Flashcard> get flashcards => _filteredCards;
  int get currentIndex => _currentIndex;
  String get searchQuery => _searchQuery;

  Flashcard? get currentCard {
    if (_filteredCards.isEmpty || _currentIndex >= _filteredCards.length) return null;
    return _filteredCards[_currentIndex];
  }

  // Statistics getters
  int get totalCount => _flashcards.length;
  int get favoriteCount => _flashcards.where((c) => c.isFavorite).length;
  int get studiedCount => _flashcards.where((c) => c.isStudied).length;
  double get completionPercentage {
    if (_flashcards.isEmpty) return 0.0;
    return (_flashcards.where((c) => c.isStudied).length / _flashcards.length);
  }

  void loadFlashcards() {
    _flashcards = _storageService.getFlashcards();
    _applyFilterAndSync();
  }

  void _applyFilterAndSync() {
    if (_searchQuery.isEmpty) {
      _filteredCards = List.from(_flashcards);
    } else {
      _filteredCards = _flashcards
          .where((card) =>
      card.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          card.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_currentIndex >= _filteredCards.length) {
      _currentIndex = _filteredCards.isEmpty ? 0 : _filteredCards.length - 1;
    }
    notifyListeners();
  }

  void nextCard() {
    if (_currentIndex < _filteredCards.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousCard() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilterAndSync();
  }

  void shuffle() {
    _filteredCards.shuffle();
    _currentIndex = 0;
    notifyListeners();
  }
  Future<void> generateBatchWithAI(String topic) async {
    _isGenerating = true;
    notifyListeners(); // Tells the UI to display the loading indicator

    try {
      final rawCards = await _aiService.generateFlashcards(topic);

      for (var cardData in rawCards) {
        final newCard = Flashcard(
          id: (DateTime.now().millisecondsSinceEpoch + rawCards.indexOf(cardData)).toString(),
          question: cardData['question']!,
          answer: cardData['answer']!,
        );
        _flashcards.add(newCard);
        await _storageService.saveFlashcard(newCard); // Saves directly to local Hive storage
      }

      _applyFilterAndSync(); // Triggers your local view filters if you have them
    } finally {
      _isGenerating = false;
      notifyListeners(); // Turns off loading spinner once finished
    }
  }

  // Your existing helper function (make sure the name matches yours, e.g., _applyFilterAndSync or notifyListeners)
  

  Future<void> addCard(String question, String answer) async {
    final newCard = Flashcard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: question,
      answer: answer,
    );
    _flashcards.add(newCard);
    await _storageService.saveFlashcard(newCard);
    _applyFilterAndSync();
  }

  Future<void> updateCard(String id, String question, String answer) async {
    final idx = _flashcards.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _flashcards[idx].question = question;
      _flashcards[idx].answer = answer;
      await _storageService.saveFlashcard(_flashcards[idx]);
      _applyFilterAndSync();
    }
  }

  Future<void> toggleFavorite(String id) async {
    final idx = _flashcards.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _flashcards[idx].isFavorite = !_flashcards[idx].isFavorite;
      await _storageService.saveFlashcard(_flashcards[idx]);
      _applyFilterAndSync();
    }
  }

  Future<void> markAsStudied(String id) async {
    final idx = _flashcards.indexWhere((c) => c.id == id);
    if (idx != -1 && !_flashcards[idx].isStudied) {
      _flashcards[idx].isStudied = true;
      await _storageService.saveFlashcard(_flashcards[idx]);
      _applyFilterAndSync();
    }
  }

  Future<void> deleteCard(String id) async {
    _flashcards.removeWhere((c) => c.id == id);
    await _storageService.deleteFlashcard(id);
    _applyFilterAndSync();
  }
}