import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dummy notification list
  List<String> _notifications = [
    'Notification 1: Your order has been shipped.',
    'Notification 2: Your payment was successful.',
    'Notification 3: New message from John Doe.',
    'Notification 4: Your appointment is confirmed.',
    'Notification 5: Special offer just for you!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: _notifications.isNotEmpty
                  ? ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_notifications[index]),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No notifications available'),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _notifications.clear();
                });
              },
              child: const Text('Clear Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
