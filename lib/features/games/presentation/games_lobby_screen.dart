import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class GamesLobbyScreen extends StatelessWidget {
  const GamesLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Couple Games', style: TextStyle(color: AppColors.primary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildGameCard(
            context,
            title: "This or That",
            description: "Beach or Mountains? See how aligned you really are.",
            icon: Icons.compare_arrows,
            route: '/games/this_or_that',
          ),
          const SizedBox(height: 24),
          _buildGameCard(
            context,
            title: "Truth or Dare",
            description: "Keep it fun and spontaneous.",
            icon: Icons.casino,
            route: '/games/truth_dare',
          ),
          const SizedBox(height: 24),
          _buildGameCard(
            context,
            title: "Partner Quiz",
            description: "How well do you know their favorites?",
            icon: Icons.quiz,
            route: '/games/quiz',
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, {required String title, required String description, required IconData icon, required String route}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                  child: Icon(icon, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(description, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => context.push(route),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: const Text("Play Game", style: TextStyle(color: AppColors.surface, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
