import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../models/announcement_model.dart';
import '../../../providers/feature_providers.dart';

class AnnouncementFormPage extends ConsumerStatefulWidget {
  final AnnouncementModel? announcement;

  const AnnouncementFormPage({super.key, this.announcement});

  @override
  ConsumerState<AnnouncementFormPage> createState() =>
      _AnnouncementFormPageState();
}

class _AnnouncementFormPageState extends ConsumerState<AnnouncementFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _priority;
  late String _category;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.announcement?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.announcement?.content ?? '',
    );
    _priority = widget.announcement?.priority ?? 'normal';
    _category = widget.announcement?.category ?? 'general';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final announcement = AnnouncementModel(
        id: widget.announcement?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        priority: _priority,
        category: _category,
        createdAt: widget.announcement?.createdAt ?? DateTime.now(),
      );

      final service = ref.read(announcementServiceProvider);

      if (widget.announcement == null) {
        await service.createAnnouncement(announcement);
      } else {
        await service.updateAnnouncement(announcement);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.announcement == null
                  ? 'Pengumuman berhasil dibuat'
                  : 'Pengumuman berhasil diperbarui',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.announcement != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Pengumuman' : 'Buat Pengumuman'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul harus diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Prioritas'),
                items: ['low', 'normal', 'high']
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: ['general', 'academic', 'event', 'urgent']
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Konten',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty
                    ? 'Konten harus diisi'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAnnouncement,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(isEditing ? 'Simpan Perubahan' : 'Buat Pengumuman'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
