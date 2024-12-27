import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/guest.dart';

class AddGuestScreen extends StatefulWidget {
  @override
  _AddGuestScreenState createState() => _AddGuestScreenState();
}

class _AddGuestScreenState extends State<AddGuestScreen> {
  final _nameController = TextEditingController();
  final _plateController = TextEditingController();
  final _purposeController = TextEditingController();

  void _saveGuest() {
    final name = _nameController.text;
    final plate = _plateController.text;
    final purpose = _purposeController.text;

    if (name.isNotEmpty && plate.isNotEmpty && purpose.isNotEmpty) {
      final newGuest = Guest(
        name: name,
        plateNumber: plate,
        purpose: purpose,
        checkInTime: DateTime.now(),
      );

      DatabaseService().insertGuest(newGuest).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Guest')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _plateController,
              decoration: InputDecoration(labelText: 'Plate Number'),
            ),
            TextField(
              controller: _purposeController,
              decoration: InputDecoration(labelText: 'Purpose'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGuest,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
