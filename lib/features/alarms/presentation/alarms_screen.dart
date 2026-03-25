import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class AlarmsScreen extends ConsumerWidget {
  const AlarmsScreen({super.key});

  void _showCreateAlarmSheet(BuildContext context) {
    // Scaffold UI context for bottom sheet
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now we will mock this until alarm provider is linked
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shared Alarms', style: TextStyle(color: AppColors.primary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text("Alarms UI coming soon", style: TextStyle(color: AppColors.mutedText)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showCreateAlarmSheet(context),
        child: const Icon(Icons.alarm_add, color: AppColors.surface, size: 32),
      ),
    );
  }
}
