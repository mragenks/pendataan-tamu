import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'guest_list_screen.dart';
import 'add_guest_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Dashboard'),
  actions: [
    IconButton(
      icon: Icon(Icons.logout),
      onPressed: () async {
        await AuthService().logout();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      },
    ),
  ],
),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Guest Management System',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuestListScreen()),
                );
              },
              child: Text('View Guest List'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddGuestScreen()),
                );
              },
              child: Text('Add Guest'),
            ),
          ],
        ),
      ),
    );
  }
}
