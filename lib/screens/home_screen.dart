import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../widgets/stats_panel.dart';
import '../widgets/flashcard_dialog.dart';
import '../animations/flip_animation.dart';
import 'favorites_screen.dart';
import '../widgets/ai_generator_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showFront = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => FlashcardDialog(
        onSave: (q, a) => context.read<FlashcardProvider>().addCard(q, a),
      ),
    );
  }


  void _showEditDialog(BuildContext context, String id, String q, String a) {
    showDialog(
      context: context,
      builder: (ctx) => FlashcardDialog(
        initialQuestion: q,
        initialAnswer: a,
        onSave: (newQ, newA) => context.read<FlashcardProvider>().updateCard(id, newQ, newA),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primaryDeep,
        title: const Text('Delete Flashcard?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              context.read<FlashcardProvider>().deleteCard(id);
              Navigator.pop(ctx);
            },
            child: const Text('DELETE', style: TextStyle(color: AppColors.neonPink)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();
    final currentCard = provider.currentCard;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.bgGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Bar Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('CORE.MEM', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.neonYellow)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shuffle, color: Colors.white),
                          onPressed: () => provider.shuffle(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.star, color: AppColors.neonPink),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Stats Architecture Panel
                StatsPanel(
                  total: provider.totalCount,
                  favorites: provider.favoriteCount,
                  progress: provider.completionPercentage,
                ),
                const SizedBox(height: 16),

                // Search field implementation
                TextField(
                  controller: _searchController,
                  onChanged: (v) => provider.search(v),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search runtime systems...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: AppColors.glassSurface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),

                // Dynamic Workspace / Deck View
                Expanded(
                  child: provider.flashcards.isEmpty
                      ? _buildEmptyState(context)
                      : Column(
                    children: [
                      // Linear Animated Metrics Progress bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CARD ${provider.currentIndex + 1} OF ${provider.flashcards.length}',
                            style: const TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1.1),
                          ),
                          if (currentCard?.isStudied ?? false)
                            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: provider.flashcards.isEmpty ? 0 : (provider.currentIndex + 1) / provider.flashcards.length,
                        backgroundColor: AppColors.glassSurface,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonPink),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 24),

                      // Display Core Animated Flashcard Deck Structure
                      Expanded(
                        child: GestureDetector(
                          onLongPress: () {
                            if (currentCard != null) {
                              _showEditDialog(context, currentCard.id, currentCard.question, currentCard.answer);
                            }
                          },
                          child: FlipAnimation(
                            showFront: _showFront,
                            front: _buildCardSide(
                              context,
                              text: currentCard?.question ?? '',
                              label: 'QUESTION',
                              action: NeonButton(
                                text: 'REVEAL ANSWER',
                                onPressed: () => setState(() => _showFront = false),
                              ),
                              cardId: currentCard?.id,
                            ),
                            back: _buildCardSide(
                              context,
                              text: currentCard?.answer ?? '',
                              label: 'SOLUTION MATRIX',
                              action: NeonButton(
                                text: 'MARK AS MASTERED',
                                neonColor: Colors.greenAccent,
                                onPressed: () {
                                  if (currentCard != null) {
                                    provider.markAsStudied(currentCard.id);
                                    setState(() => _showFront = true);
                                    provider.nextCard();
                                  }
                                },
                              ),
                              cardId: currentCard?.id,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Controls Interface Deck Layout
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                            onPressed: provider.currentIndex > 0 ? () {
                              setState(() => _showFront = true);
                              provider.previousCard();
                            } : null,
                          ),
                          TextButton(
                            onPressed: () => setState(() => _showFront = !_showFront),
                            child: const Text('FLIP DECK', style: TextStyle(color: AppColors.neonYellow)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                            onPressed: provider.currentIndex < provider.flashcards.length - 1 ? () {
                              setState(() => _showFront = true);
                              provider.nextCard();
                            } : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // 🌟 FIXED: Stacked Floating Actions correctly bounded inside the Scaffold property drawer
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. AI Flashcard Creator Matrix Button
          FloatingActionButton(
            heroTag: 'ai_btn',
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.neonYellow, width: 1.5),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AIGeneratorSheet(),
              );
            },
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.neonYellow, size: 24),
          ),
          const SizedBox(height: 12),

          // 2. Manual Custom Card Addition Button
          FloatingActionButton(
            heroTag: 'manual_btn',
            backgroundColor: AppColors.neonPink,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            onPressed: () => _showAddDialog(context),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSide(BuildContext context, {required String text, required String label, required Widget action, String? cardId}) {
    final provider = context.read<FlashcardProvider>();
    final isFav = provider.flashcards.isEmpty ? false : provider.flashcards[provider.currentIndex].isFavorite;

    return GlassCard(
      glowColor: _showFront ? AppColors.neonPink : AppColors.neonYellow,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 2)),
                if (cardId != null)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isFav ? Icons.star : Icons.star_border, color: AppColors.neonPink),
                        onPressed: () => provider.toggleFavorite(cardId),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.white60),
                        onPressed: () => _confirmDelete(context, cardId),
                      ),
                    ],
                  ),
              ],
            ),
            const Spacer(),
            Center(
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Spacer(),
            action,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers_clear_outlined, size: 80, color: AppColors.neonPink.withOpacity(0.4)),
          const SizedBox(height: 24),
          Text(
            'DATA DECK EMPTY',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start learning by creating your first flashcard.',
            style: TextStyle(color: Colors.white38),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.wineRed,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => _showAddDialog(context),
            child: const Text('INITIALIZE SYSTEM', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}