import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class AIGeneratorSheet extends StatefulWidget {
  const AIGeneratorSheet({super.key});

  @override
  State<AIGeneratorSheet> createState() => _AIGeneratorSheetState();
}

class _AIGeneratorSheetState extends State<AIGeneratorSheet> {
  final TextEditingController _promptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Avoids keyboard overlap bugs
      ),
      child: GlassCard(
        glowColor: AppColors.neonYellow,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppColors.neonYellow),
                    const SizedBox(width: 10),
                    Text(
                      'AI CYPHER SYNTHESIS',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter a topic or paste study notes to instantly generate a structured flashcard deck matrix.',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _promptController,
                  maxLines: 3,
                  enabled: !provider.isGenerating,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., Clean Architecture principles in Flutter, or Quantum Computing basics...',
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.neonYellow),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please specify a payload topic' : null,
                ),
                const SizedBox(height: 24),
                provider.isGenerating
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.neonYellow)),
                  ),
                )
                    : NeonButton(
                  text: 'SYNTHESIZE DECK',
                  neonColor: AppColors.neonYellow,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await context.read<FlashcardProvider>().generateBatchWithAI(_promptController.text.trim());
                        if (mounted) Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.neonPink),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}