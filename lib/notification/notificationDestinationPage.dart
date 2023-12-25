import 'package:flutter/material.dart';
class NotificationDestination extends StatelessWidget {

  Map<String, String?> payload = {};
  @override
  Widget build(BuildContext context) {

    payload = ModalRoute.of(context)?.settings.arguments as Map<String, String?>;

    return Scaffold(
      appBar: AppBar(
        title: Text("This is notification Destination page"),
      ),
      body: Center(
        child: Text('This is a notification Destination page! $payload', style: TextStyle(fontSize: 25),),
      ),
    );
  }
}
