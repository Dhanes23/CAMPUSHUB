import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../models/academic_info_model.dart';
import '../../../providers/feature_providers.dart';

class AcademicFormPage extends ConsumerStatefulWidget {
  final AcademicInfoModel? info;

  const AcademicFormPage({super.key, this.info});

  @override
  ConsumerState<AcademicFormPage> createState() => _AcademicFormPageState();
}

class _AcademicFormPageState extends ConsumerState<AcademicFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _type;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.info?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.info?.description ?? '',
    );
    _type = widget.info?.type ?? 'schedule';
    _selectedDate = widget.info?.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveInfo() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mohon pilih tanggal')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final info = AcademicInfoModel(
        id: widget.info?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _type,
        date: _selectedDate,
        createdAt: widget.info?.createdAt ?? DateTime.now(),
      );

      final service = ref.read(academicServiceProvider);

      if (widget.info == null) {
        await service.createInfo(info);
      } else {
        await service.updateInfo(info);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.info == null
                  ? 'Informasi berhasil dibuat'
                  : 'Informasi berhasil diperbarui',
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
    final isEditing = widget.info != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Informasi Akademik' : 'Tambah Informasi Akademik',
        ),
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
                value: _type,
                decoration: const InputDecoration(labelText: 'Tipe'),
                items: ['schedule', 'exam', 'deadline']
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
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                        : 'Pilih Tanggal',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty
                    ? 'Deskripsi harus diisi'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveInfo,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(isEditing ? 'Simpan Perubahan' : 'Tambah Informasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
