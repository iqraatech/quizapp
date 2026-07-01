import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'glass_card.dart';
import 'neon_button.dart';

class FlashcardDialog extends StatefulWidget {
  final String? initialQuestion;
  final String? initialAnswer;
  final Function(String q, String a) onSave;

  const FlashcardDialog({
    super.key,
    this.initialQuestion,
    this.initialAnswer,
    required this.onSave,
  });

  @override
  State<FlashcardDialog> createState() => _FlashcardDialogState();
}

class _FlashcardDialogState extends State<FlashcardDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.initialQuestion);
    _answerController = TextEditingController(text: widget.initialAnswer);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GlassCard(
        glowColor: AppColors.neonPink,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.initialQuestion == null ? 'CREATE FLASHCARD' : 'EDIT FLASHCARD',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22, color: AppColors.neonYellow),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.neonPink)),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Field cannot be empty' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _answerController,
                  decoration: const InputDecoration(
                    labelText: 'Answer',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.neonPink)),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Field cannot be empty' : null,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL', style: TextStyle(color: Colors.white60)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: NeonButton(
                        text: 'SAVE',
                        neonColor: AppColors.neonYellow,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onSave(_questionController.text.trim(), _answerController.text.trim());
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}