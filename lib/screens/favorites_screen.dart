import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/glass_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FlashcardProvider>().flashcards.where((c) => c.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAVORITE DECKS', style: TextStyle(fontSize: 18, letterSpacing: 1.5)),
        backgroundColor: AppColors.darkBg,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.bgGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: favorites.isEmpty
            ? const Center(child: Text('No starred components.', style: TextStyle(color: Colors.white38)))
            : ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final card = favorites[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              key: ValueKey(card.id),
              child: GlassCard(
                glowColor: AppColors.neonPink,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(card.question, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(card.answer, style: const TextStyle(color: AppColors.neonYellow)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.star, color: AppColors.neonPink),
                    onPressed: () => context.read<FlashcardProvider>().toggleFavorite(card.id),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}