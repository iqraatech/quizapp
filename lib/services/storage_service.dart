import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard.dart';

class StorageService {
  static const String _boxName = 'flashcards_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    // Hive.registerAdapter(FlashcardAdapter());
    await Hive.openBox<Flashcard>(_boxName);
  }

  Box<Flashcard> get _box => Hive.box<Flashcard>(_boxName);

  List<Flashcard> getFlashcards() {
    return _box.values.toList();
  }

  Future<void> saveFlashcard(Flashcard card) async {
    await _box.put(card.id, card);
  }

  Future<void> deleteFlashcard(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}