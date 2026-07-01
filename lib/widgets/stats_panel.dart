import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'glass_card.dart';

class StatsPanel extends StatelessWidget {
  final int total;
  final int favorites;
  final double progress;

  const StatsPanel({
    super.key,
    required this.total,
    required this.favorites,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowColor: AppColors.wineRed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Fully fixed with lowercase 'a'
          children: [
            _buildStatItem('TOTAL', total.toString(), AppColors.neonYellow),
            _buildStatItem('STARS', favorites.toString(), AppColors.neonPink),
            _buildStatItem('MASTERED', '${(progress * 100).toStringAsFixed(0)}%', Colors.greenAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 11, letterSpacing: 1.5, color: Colors.white.withOpacity(0.5))),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}