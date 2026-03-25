import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import 'dart:async';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final String noteId;
  const NoteDetailScreen({super.key, required this.noteId});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  String _currentColor = '#FFF9C4';
  bool _isPinned = false;
  bool _isNew = false;
  Timer? _debounce;
  
  @override
  void initState() {
    super.initState();
    _isNew = widget.noteId == 'new';
    if (!_isNew) {
      _loadNote();
    }
  }

  Future<void> _loadNote() async {
    final note = await Supabase.instance.client
        .from('notes')
        .select()
        .eq('id', widget.noteId)
        .maybeSingle();
        
    if (note != null && mounted) {
      setState(() {
        _titleController.text = note['title'] ?? '';
        _contentController.text = note['content'] ?? '';
        _currentColor = note['color'] ?? '#FFF9C4';
        _isPinned = note['is_pinned'] ?? false;
      });
    }
  }

  void _onChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _saveNote();
    });
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    final profile = ref.read(currentUserProfileProvider).value;
    if (profile == null) return;

    final noteData = {
      'couple_id': profile['couple_id'],
      'title': title,
      'content': content,
      'color': _currentColor,
      'is_pinned': _isPinned,
      'updated_by': profile['id'],
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (_isNew) {
      noteData['created_by'] = profile['id'];
      await Supabase.instance.client.from('notes').insert(noteData).select().single();
      _isNew = false; // Transition from insert to update
      // In a real app we might redirect to the new ID instead of keeping 'new' in state
    } else {
      await Supabase.instance.client.from('notes').update(noteData).eq('id', widget.noteId);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(int.parse(_currentColor.replaceFirst('#', '0xFF')));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined, color: AppColors.primary),
            onPressed: () {
              setState(() => _isPinned = !_isPinned);
              _saveNote();
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: AppColors.primary),
            onPressed: () {}, // Voice notes placeholder
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                onChanged: (_) => _onChanged(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.primary),
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                  border: InputBorder.none,
                  filled: false,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  onChanged: (_) => _onChanged(),
                  maxLines: null,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Start pouring your heart out...',
                    border: InputBorder.none,
                    filled: false,
                  ),
                ),
              ),
              _buildColorPicker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = ['#FFF9C4', '#F48FB1', '#90CAF9', '#A5D6A7', '#CE93D8'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: colors.map((c) {
          final colorVal = Color(int.parse(c.replaceFirst('#', '0xFF')));
          final isSelected = _currentColor == c;
          return GestureDetector(
            onTap: () {
              setState(() => _currentColor = c);
              _saveNote();
            },
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: colorVal,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.primary : Colors.black12, width: isSelected ? 2 : 1),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
