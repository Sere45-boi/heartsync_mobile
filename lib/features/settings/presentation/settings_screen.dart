import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppColors.primary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSection("Profile", [
            ListTile(title: const Text("Change Display Name"), onTap: () {}),
            ListTile(title: const Text("Change Avatar"), onTap: () {}),
          ]),
          _buildSection("Connection", [
            ListTile(
              title: const Text("Disconnect Partner", style: TextStyle(color: AppColors.error)),
              onTap: () {},
            ),
          ]),
          _buildSection("Notifications", [
            SwitchListTile(title: const Text("Shared Alarms"), value: true, onChanged: (v) {}),
            SwitchListTile(title: const Text("Partner Nudges"), value: true, onChanged: (v) {}),
          ]),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _logout(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(title, style: const TextStyle(color: AppColors.mutedText, letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
