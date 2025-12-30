import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../models/job_model.dart';
import '../../../providers/feature_providers.dart';

class JobFormPage extends ConsumerStatefulWidget {
  final JobModel? job;

  const JobFormPage({super.key, this.job});

  @override
  ConsumerState<JobFormPage> createState() => _JobFormPageState();
}

class _JobFormPageState extends ConsumerState<JobFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _companyController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _applyLinkController;
  late String _type;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.job?.title ?? '');
    _companyController = TextEditingController(text: widget.job?.company ?? '');
    _descriptionController = TextEditingController(
      text: widget.job?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.job?.location ?? '',
    );
    _applyLinkController = TextEditingController(
      text: widget.job?.applyLink ?? '',
    );
    _type = widget.job?.type ?? 'internship';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _applyLinkController.dispose();
    super.dispose();
  }

  Future<void> _saveJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final job = JobModel(
        id: widget.job?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        company: _companyController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _type,
        location: _locationController.text.trim().isNotEmpty
            ? _locationController.text.trim()
            : null,
        applyLink: _applyLinkController.text.trim().isNotEmpty
            ? _applyLinkController.text.trim()
            : null,
        createdAt: widget.job?.createdAt ?? DateTime.now(),
      );

      final service = ref.read(jobServiceProvider);

      if (widget.job == null) {
        await service.createJob(job);
      } else {
        await service.updateJob(job);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.job == null
                  ? 'Lowongan berhasil dibuat'
                  : 'Lowongan berhasil diperbarui',
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
    final isEditing = widget.job != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Lowongan' : 'Tambah Lowongan'),
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
                decoration: const InputDecoration(labelText: 'Posisi / Judul'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Posisi harus diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Perusahaan'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama perusahaan harus diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Tipe Pekerjaan'),
                items: ['internship', 'fulltime', 'parttime']
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _type = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi (Opsional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _applyLinkController,
                decoration: const InputDecoration(
                  labelText: 'Link Pendaftaran (Opsional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Pekerjaan',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty
                    ? 'Deskripsi harus diisi'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveJob,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(isEditing ? 'Simpan Perubahan' : 'Tambah Lowongan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
