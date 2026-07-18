import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/network/dio_client.dart';
import '../../../models/event.dart';
import '../../../data/repositories/event_repository.dart';
import '../organizer_events_provider.dart';

/// Create/edit form for an event. Pass [event] to edit an existing one.
class EventFormScreen extends ConsumerStatefulWidget {
  const EventFormScreen({super.key, this.event});

  final Event? event;

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _locationController;
  late final TextEditingController _capacityController;
  late final TextEditingController _priceController;
  late final TextEditingController _tagsController;
  late DateTime _date;
  late bool _isFree;
  XFile? _pickedPoster;
  bool _saving = false;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _titleController = TextEditingController(text: e?.title ?? '');
    _descriptionController = TextEditingController(text: e?.description ?? '');
    _categoryController = TextEditingController(text: e?.category ?? '');
    _locationController = TextEditingController(text: e?.location ?? '');
    _capacityController = TextEditingController(text: e?.capacity.toString() ?? '');
    _priceController = TextEditingController(text: e?.price.toString() ?? '0');
    _tagsController = TextEditingController(text: e?.tags.join(', ') ?? '');
    _date = e?.date ?? DateTime.now().add(const Duration(days: 7));
    _isFree = e?.isFree ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_date));
    if (time == null) return;
    setState(() {
      _date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _pickPoster() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _pickedPoster = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final draft = EventDraft(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        date: _date,
        location: _locationController.text.trim(),
        capacity: int.parse(_capacityController.text.trim()),
        price: _isFree ? 0 : num.tryParse(_priceController.text.trim()) ?? 0,
        isFree: _isFree,
        tags: _tagsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
      );

      final actions = ref.read(organizerEventActionsProvider.notifier);
      if (_isEditing) {
        await actions.update(widget.event!.id, draft, posterPath: _pickedPoster?.path);
      } else {
        await actions.create(draft, posterPath: _pickedPoster?.path);
      }
      if (mounted) context.pop();
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit event' : 'Create event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickPoster,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    image: _pickedPoster != null
                        ? DecorationImage(image: FileImage(File(_pickedPoster!.path)), fit: BoxFit.cover)
                        : (widget.event?.posterUrl != null && widget.event!.posterUrl!.isNotEmpty)
                            ? DecorationImage(image: NetworkImage(widget.event!.posterUrl!), fit: BoxFit.cover)
                            : null,
                  ),
                  child: (_pickedPoster == null && (widget.event?.posterUrl == null || widget.event!.posterUrl!.isEmpty))
                      ? const Center(child: Icon(Icons.add_photo_alternate_outlined, size: 40))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date & time'),
                subtitle: Text(DateFormat('EEE, MMM d, y · h:mm a').format(_date)),
                trailing: const Icon(Icons.edit_calendar_outlined),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
                validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a number' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Free event'),
                value: _isFree,
                onChanged: (v) => setState(() => _isFree = v),
              ),
              if (!_isFree)
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(labelText: 'Tags (comma separated)'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_isEditing ? 'Save changes' : 'Create event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
