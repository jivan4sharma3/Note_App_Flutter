import 'package:flutter/material.dart';
import 'package:notesapp/main.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;
  final bool isEditing;

  const NoteScreen({
    super.key,
    this.note,
    required this.isEditing,
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late int selectedColorIndex;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
    selectedColorIndex = widget.note?.color ?? 0;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Note' : 'New Note',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                Navigator.pop(context, 'delete');
              },
            ),
          TextButton(
            onPressed: _saveNote,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color picker
            const Text(
              'Choose Color',
              style: TextStyle(
                color: AppColors.subtleText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppColors.noteColors.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedColorIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColorIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.noteColors[index],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.accent : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Note title...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.subtleText,
                ),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            // Content
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                hintText: 'Write your note here...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: AppColors.subtleText,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                height: 1.5,
              ),
              maxLines: null,
              minLines: 10,
            ),
            const SizedBox(height: 20),
            // Last updated
            if (widget.isEditing && widget.note != null)
              Text(
                'Last updated: ${_formatDate(widget.note!.updatedAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.subtleText.withOpacity(0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title or content'),
          backgroundColor: AppColors.accent,
        ),
      );
      return;
    }

    final note = Note(
      id: widget.note?.id,
      title: title.isEmpty ? 'Untitled' : title,
      content: content,
      color: selectedColorIndex,
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, note);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}