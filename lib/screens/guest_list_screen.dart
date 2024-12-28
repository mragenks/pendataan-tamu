import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/guest.dart';

class GuestListScreen extends StatefulWidget {
  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  late Future<List<Guest>> _guestList;
  List<Guest> _checkedOutGuests = [];

  @override
  void initState() {
    super.initState();
    _guestList = Future.value([]);
    _refreshGuestLists();
  }

  void _refreshGuestLists() {
    final guests = DatabaseService().fetchGuests();
    guests.then((data) {
      setState(() {
        _guestList =
            Future.value(data.where((g) => g.checkOutTime == null).toList());
        _checkedOutGuests = data.where((g) => g.checkOutTime != null).toList();
      });
    });
  }

  void _resetData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Data'),
          content: Text(
              'Are you sure you want to reset all guest data? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseService().resetData().then((_) {
                  _refreshGuestLists();
                  Navigator.of(context).pop();
                });
              },
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditScreen(BuildContext context, Guest guest) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditGuestScreen(guest: guest),
          ),
        )
        .then((_) => _refreshGuestLists());
  }

  void _confirmCheckout(BuildContext context, Guest guest) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Checkout'),
          content: Text('Are you sure you want to check out this guest?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseService().checkoutGuest(guest.id!).then((_) {
                  _refreshGuestLists();
                  Navigator.of(context).pop();
                });
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Guest List'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () => _resetData(context),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Active Guests'),
              Tab(text: 'Checked Out'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Active Guests Tab
            FutureBuilder<List<Guest>>(
              future: _guestList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading guests.'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text('No active guests found.'));
                } else {
                  final guests = snapshot.data!;
                  return ListView.builder(
                    itemCount: guests.length,
                    itemBuilder: (context, index) {
                      final guest = guests[index];
                      return ListTile(
                        title: Text(guest.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Plate: ${guest.plateNumber}'),
                            Text('Check in: ${guest.formattedCheckInTime}'),
                          ],
                        ),
                        onTap: () => _navigateToEditScreen(context, guest),
                        trailing: IconButton(
                          icon: Icon(Icons.exit_to_app, color: Colors.red),
                          onPressed: () => _confirmCheckout(context, guest),
                        ),
                      );
                    },
                  );
                }
              },
            ),

            // Checked Out Guests Tab
            _checkedOutGuests.isEmpty
                ? Center(child: Text('No checked out guests found.'))
                : ListView.builder(
                    itemCount: _checkedOutGuests.length,
                    itemBuilder: (context, index) {
                      final guest = _checkedOutGuests[index];
                      return ListTile(
                        title: Text(guest.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Plate: ${guest.plateNumber}'),
                            Text('Check in: ${guest.formattedCheckInTime}'),
                            Text('Checked out at: ${guest.formattedCheckOutTime}'),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class EditGuestScreen extends StatefulWidget {
  final Guest guest;

  EditGuestScreen({required this.guest});

  @override
  _EditGuestScreenState createState() => _EditGuestScreenState();
}

class _EditGuestScreenState extends State<EditGuestScreen> {
  late TextEditingController _nameController;
  late TextEditingController _plateController;
  late TextEditingController _purposeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.guest.name);
    _plateController = TextEditingController(text: widget.guest.plateNumber);
    _purposeController = TextEditingController(text: widget.guest.purpose);
  }

  void _saveGuest() {
    final updatedGuest = Guest(
      id: widget.guest.id,
      name: _nameController.text,
      plateNumber: _plateController.text,
      purpose: _purposeController.text,
      checkInTime: widget.guest.checkInTime,
      checkOutTime: widget.guest.checkOutTime,
    );

    DatabaseService().updateGuest(updatedGuest).then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Guest')),
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
