import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shared Notes', style: TextStyle(color: AppColors.primary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text("No notes yet. Start sharing!", style: TextStyle(color: AppColors.mutedText)));
          }
          final pinned = notes.where((n) => n['is_pinned'] == true).toList();
          final unpinned = notes.where((n) => n['is_pinned'] != true).toList();

          return CustomScrollView(
            slivers: [
              if (pinned.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text("📌 Pinned", style: TextStyle(color: AppColors.mutedText, fontWeight: FontWeight.bold)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: pinned.length,
                      itemBuilder: (context, index) => _NoteCard(note: pinned[index]),
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _NoteCard(note: unpinned[index]),
                    childCount: unpinned.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text("Error loading notes: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push('/notes/new'),
        child: const Icon(Icons.add, color: AppColors.surface, size: 32),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    final colorString = note['color'] as String? ?? '#FFF9C4';
    final cardColor = Color(int.parse(colorString.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: () => context.push('/notes/${note['id']}'),
      child: Container(
        width: 140, // Useful for horizontal pinned list
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note['is_pinned'] == true) 
              const Align(alignment: Alignment.topRight, child: Icon(Icons.push_pin, size: 16, color: AppColors.primary)),
            Text(
              note['title'] ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.primary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                note['content'] ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary.withValues(alpha: 0.8)),
                maxLines: 4,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
