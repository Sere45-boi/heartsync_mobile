import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showCreateTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateTaskSheet(),
    );
  }

  Future<void> _toggleTask(Map<String, dynamic> task) async {
    final isCompleted = !(task['is_completed'] as bool? ?? false);
    await Supabase.instance.client
        .from('tasks')
        .update({'is_completed': isCompleted})
        .eq('id', task['id']);
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shared Tasks', style: TextStyle(color: AppColors.primary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.mutedText,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: "Our Tasks"), Tab(text: "Done")],
        ),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final pending = tasks.where((t) => t['is_completed'] != true).toList();
          final done = tasks.where((t) => t['is_completed'] == true).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTaskList(pending, "No pending tasks. You're all caught up!"),
              _buildTaskList(done, "No completed tasks yet."),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showCreateTaskSheet,
        child: const Icon(Icons.add, color: AppColors.surface, size: 32),
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, dynamic>> tasks, String emptyMsg) {
    if (tasks.isEmpty) {
      return Center(child: Text(emptyMsg, style: const TextStyle(color: AppColors.mutedText)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final t = tasks[index];
        final isDone = t['is_completed'] == true;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _toggleTask(t),
                child: Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: isDone ? AppColors.primary : Colors.transparent,
                    border: Border.all(color: AppColors.primary, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: isDone ? const Icon(Icons.check, size: 16, color: AppColors.surface) : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  t['title'] ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? AppColors.mutedText : AppColors.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text("shared", style: TextStyle(fontSize: 12, color: AppColors.primary)),
              )
            ],
          ),
        );
      },
    );
  }
}

class _CreateTaskSheet extends ConsumerStatefulWidget {
  const _CreateTaskSheet();
  @override
  ConsumerState<_CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends ConsumerState<_CreateTaskSheet> {
  final _titleController = TextEditingController();

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    final profile = ref.read(currentUserProfileProvider).value;
    if (profile == null) return;

    await Supabase.instance.client.from('tasks').insert({
      'couple_id': profile['couple_id'],
      'title': title,
      'created_by': profile['id'],
    });

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Add to our list", style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: const InputDecoration(hintText: "What do we need to do?"),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            child: const Text("Add Task"),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
