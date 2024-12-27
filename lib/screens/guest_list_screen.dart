import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/guest.dart';

class GuestListScreen extends StatefulWidget {
  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  late Future<List<Guest>> _guestList;

  @override
  void initState() {
    super.initState();
    _guestList = DatabaseService().fetchGuests();
  }

  void _showEditDialog(BuildContext context, Guest guest) {
    final nameController = TextEditingController(text: guest.name);
    final plateController = TextEditingController(text: guest.plateNumber);
    final purposeController = TextEditingController(text: guest.purpose);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Guest'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: plateController,
                decoration: InputDecoration(labelText: 'Plate Number'),
              ),
              TextField(
                controller: purposeController,
                decoration: InputDecoration(labelText: 'Purpose'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedGuest = Guest(
                  id: guest.id,
                  name: nameController.text,
                  plateNumber: plateController.text,
                  purpose: purposeController.text,
                  checkInTime: guest.checkInTime,
                  checkOutTime: guest.checkOutTime,
                );

                DatabaseService().updateGuest(updatedGuest).then((_) {
                  setState(() {
                    _guestList = DatabaseService().fetchGuests();
                  });
                  Navigator.of(context).pop();
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Guest List')),
      body: FutureBuilder<List<Guest>>(
        future: _guestList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading guests.'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No guests found.'));
          } else {
            final guests = snapshot.data!;
            return ListView.builder(
              itemCount: guests.length,
              itemBuilder: (context, index) {
                final guest = guests[index];
                return ListTile(
                  title: Text(guest.name),
                  subtitle: Text('Plate: ${guest.plateNumber}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(context, guest);
                        },
                      ),
                      if (guest.checkOutTime == null)
                        IconButton(
                          icon: Icon(Icons.exit_to_app, color: Colors.red),
                          onPressed: () {
                            DatabaseService().checkoutGuest(guest.id!).then((_) {
                              setState(() {
                                _guestList = DatabaseService().fetchGuests();
                              });
                            });
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
