import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class WatchLobbyScreen extends ConsumerWidget {
  const WatchLobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark cinematic theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.play_circle_fill, size: 120, color: AppColors.background),
              const SizedBox(height: 48),
              Text(
                "Movie Night",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Paste a video URL to start watching together in perfect sync.",
                style: TextStyle(color: AppColors.mutedText, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                style: const TextStyle(color: AppColors.primary),
                decoration: InputDecoration(
                  hintText: "https://... (.mp4, YouTube)",
                  fillColor: AppColors.surface.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {}, // Start Session Logic
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text("Start Watching", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
