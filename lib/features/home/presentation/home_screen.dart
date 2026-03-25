import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final String _partnerName = "Partner";
  final String _partnerMood = "☁️ sleeping";
  
  @override
  void initState() {
    super.initState();
    _fetchPartnerData();
  }

  Future<void> _fetchPartnerData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('HeartSync', style: TextStyle(color: AppColors.primary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPresenceCard(),
            const SizedBox(height: 32),
            _buildMoodSelector(),
            const SizedBox(height: 32),
            const Text("─── your shared space ───", 
              textAlign: TextAlign.center, 
              style: TextStyle(color: AppColors.mutedText)),
            const SizedBox(height: 24),
            _buildFeatureGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildPresenceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4687E).withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.background,
            child: Icon(Icons.person, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_partnerName, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(color: AppColors.offline, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    const Text("Offline right now"),
                  ],
                ),
                const SizedBox(height: 4),
                Text('"$_partnerMood"', style: const TextStyle(color: AppColors.mutedText, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Your mood today?", style: TextStyle(color: AppColors.mutedText)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ["😊", "😴", "🥰", "🌧️", "🔥", "🤍"].map((emoji) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'icon': '📝', 'label': 'Notes'},
      {'icon': '🎬', 'label': 'Watch'},
      {'icon': '🎮', 'label': 'Games'},
      {'icon': '✅', 'label': 'Tasks'},
      {'icon': '⏰', 'label': 'Alarm'},
      {'icon': '📍', 'label': 'Where'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final f = features[index];
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(f['icon']!, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(f['label']!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      },
    );
  }
}
