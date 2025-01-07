import 'package:flutter/material.dart';
import 'package:pendataan_tamu_perumahan/models/guest.dart';
import 'package:pendataan_tamu_perumahan/services/database_service.dart';

class EditGuestScreen extends StatefulWidget {
  final Guest guest;

  EditGuestScreen({required this.guest});

  @override
  _EditGuestScreenState createState() => _EditGuestScreenState();
}

class _EditGuestScreenState extends State<EditGuestScreen> {
  late TextEditingController _nameController;
  late TextEditingController _plateAlphaController;
  late TextEditingController _plateNumberController;
  late TextEditingController _plateSuffixController;
  late TextEditingController _purposeController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.guest.name);

    final plateParts = widget.guest.plateNumber.split(' ');
    _plateAlphaController = TextEditingController(text: plateParts.length > 0 ? plateParts[0] : '');
    _plateNumberController = TextEditingController(text: plateParts.length > 1 ? plateParts[1] : '');
    _plateSuffixController = TextEditingController(text: plateParts.length > 2 ? plateParts[2] : '');

    _purposeController = TextEditingController(text: widget.guest.purpose);
  }

  void _saveGuest() {
    if (_formKey.currentState!.validate()) {
      final updatedGuest = Guest(
        id: widget.guest.id,
        name: _nameController.text.trim(),
        plateNumber: '${_plateAlphaController.text.trim()} ${_plateNumberController.text.trim()} ${_plateSuffixController.text.trim()}'.trim(),
        purpose: _purposeController.text.trim(),
        checkInTime: widget.guest.checkInTime,
        checkOutTime: widget.guest.checkOutTime,
      );

      DatabaseService().updateGuest(updatedGuest).then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Guest')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: _plateAlphaController,
                      decoration: InputDecoration(labelText: 'Plate Alpha', border: OutlineInputBorder()),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (!RegExp(r'^[A-Z]{1,2}\$').hasMatch(value)) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    flex: 3,
                    child: TextFormField(
                      controller: _plateNumberController,
                      decoration: InputDecoration(labelText: 'Plate Number', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (!RegExp(r'^\d{1,4}\$').hasMatch(value)) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: _plateSuffixController,
                      decoration: InputDecoration(labelText: 'Plate Suffix (Optional)', border: OutlineInputBorder()),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 3,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && !RegExp(r'^[A-Z]{1,3}\$').hasMatch(value)) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                decoration: InputDecoration(labelText: 'Purpose', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Purpose is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveGuest,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
