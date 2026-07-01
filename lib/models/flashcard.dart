import 'package:hive/hive.dart';

// 🌟 1. Specify the part file name (must be the filename + .g.dart)
part 'flashcard.g.dart';

@HiveType(typeId: 0) // 🌟 2. Annotate the class with a unique typeId
class Flashcard extends HiveObject {
  @HiveField(0) // 🌟 3. Annotate each field with a unique index number
  String id;

  @HiveField(1)
  String question;

  @HiveField(2)
  String answer;

  @HiveField(3)
  bool isFavorite;

  @HiveField(4)
  bool isStudied;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.isFavorite = false,
    this.isStudied = false,
  });

  // 🌟 FIXED: Placed copyWith safely inside the class brackets before the final closure
  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isFavorite,
    bool? isStudied,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isFavorite: isFavorite ?? this.isFavorite,
      isStudied: isStudied ?? this.isStudied,
    );
  }
} // 👈 This closing brace now properly bounds the entire class definition