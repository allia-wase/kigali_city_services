import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/listing.dart';
import '../../services/firestore_service.dart';
import '../../providers/auth_provider.dart';

const _categories = [
  'Hospital',
  'Police Station',
  'Library',
  'Restaurant',
  'Café',
  'Park',
  'Tourist Attraction',
];

class ListingForm extends ConsumerStatefulWidget {
  final Listing? existing;
  const ListingForm({this.existing, super.key});

  @override
  ConsumerState<ListingForm> createState() => _ListingFormState();
}

class _ListingFormState extends ConsumerState<ListingForm> {
  final _formKey = GlobalKey<FormState>();
  late String name, category, address, contact, description;
  late double latitude, longitude;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      name = e.name;
      category = e.category;
      address = e.address;
      contact = e.contact;
      description = e.description;
      latitude = e.latitude;
      longitude = e.longitude;
    } else {
      name = category = address = contact = description = '';
      latitude = longitude = 0;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user =
          ref.read(authStateProvider).value; // will be non-null since nav guards
      final listing = Listing(
        id: widget.existing?.id,
        name: name,
        category: category,
        address: address,
        contact: contact,
        description: description,
        latitude: latitude,
        longitude: longitude,
        createdBy: user!.uid,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      if (widget.existing == null) {
        await FirestoreService.instance.addListing(listing);
      } else {
        await FirestoreService.instance.updateListing(listing);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  List<DropdownMenuItem<String>> get _categoryItems {
    final items = _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList();
    if (category.isNotEmpty && !_categories.contains(category)) {
      items.insert(0, DropdownMenuItem(value: category, child: Text(category)));
    }
    return items;
  }

  String? get _effectiveCategory => category.isEmpty ? null : category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'New Listing' : 'Edit Listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (v) => name = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: category.isEmpty ? null : _effectiveCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                hint: const Text('Select category'),
                items: _categoryItems,
                onChanged: (v) => setState(() => category = v ?? ''),
                onSaved: (v) => category = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (v) => address = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                initialValue: contact,
                decoration: const InputDecoration(labelText: 'Contact'),
                onSaved: (v) => contact = v ?? '',
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (v) => description = v ?? '',
                maxLines: 3,
              ),
              TextFormField(
                initialValue: latitude == 0 ? '' : latitude.toString(),
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (v) => latitude = double.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
                initialValue: longitude == 0 ? '' : longitude.toString(),
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (v) => longitude = double.tryParse(v ?? '') ?? 0,
              ),
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_error!, style: const TextStyle(color: Colors.red))),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _submit, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
