import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  String _sharingMode = 'Off'; // Off, Approximate, Exact

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Where We Are', style: TextStyle(color: AppColors.primary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("YOUR SHARING", style: TextStyle(color: AppColors.mutedText, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Off', 'Approximate', 'Exact'].map((mode) {
                final isSelected = _sharingMode == mode;
                return ChoiceChip(
                  label: Text(mode),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: isSelected ? AppColors.surface : AppColors.primary),
                  onSelected: (val) {
                    if (val) setState(() => _sharingMode = mode);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text("PARTNER'S SHARING", style: TextStyle(color: AppColors.mutedText, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            const Text("Sofia is sharing: Approximate", style: TextStyle(color: AppColors.primary, fontSize: 16)),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text("Map View Loading...", style: TextStyle(color: AppColors.mutedText)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text("✈️ Distance between you: 5,432 km", 
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
