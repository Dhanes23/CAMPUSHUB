import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/feature_providers.dart';
import '../../../models/event_model.dart';

class EventFormPage extends ConsumerStatefulWidget {
  final EventModel? event;

  const EventFormPage({super.key, this.event});

  @override
  ConsumerState<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends ConsumerState<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedCategory = 'academic';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _locationController.text = widget.event!.location;
      _imageUrlController.text = widget.event!.imageUrl ?? '';
      _selectedDate = widget.event!.date;
      _selectedTime = TimeOfDay.fromDateTime(widget.event!.date);
      _selectedCategory = widget.event!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final DateTime eventDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        final eventId = widget.event?.id ?? const Uuid().v4();

        final event = EventModel(
          id: eventId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          date: eventDateTime,
          location: _locationController.text.trim(),
          category: _selectedCategory,
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
          createdAt: widget.event?.createdAt ?? DateTime.now(),
        );

        if (widget.event == null) {
          await ref.read(eventServiceProvider).createEvent(event);
        } else {
          await ref.read(eventServiceProvider).updateEvent(event);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.event == null ? 'Event Created' : 'Event Updated',
              ),
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Create Event' : 'Edit Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter title' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'academic', child: Text('Academic')),
                  DropdownMenuItem(value: 'social', child: Text('Social')),
                  DropdownMenuItem(
                    value: 'competition',
                    child: Text('Competition'),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('d MMM yyyy').format(_selectedDate!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _selectedTime == null
                            ? 'Select Time'
                            : _selectedTime!.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter location' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (Optional)',
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _saveEvent,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.event == null ? 'Create Event' : 'Update Event',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
