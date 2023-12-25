import 'package:flutter/material.dart';

import '../service/notificationService.dart';

class NotificationDestination extends StatefulWidget {
  const NotificationDestination({super.key});

  @override
  State<NotificationDestination> createState() => _NotificationDestinationState();
}

class _NotificationDestinationState extends State<NotificationDestination> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService().closeNotificationPayload();
  }

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


// class NotificationDestination extends StatelessWidget {
//
//   Map<String, String?> payload = {};
//   @override
//   Widget build(BuildContext context) {
//
//     payload = ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("This is notification Destination page"),
//       ),
//       body: Center(
//         child: Text('This is a notification Destination page! $payload', style: TextStyle(fontSize: 25),),
//       ),
//     );
//   }
// }
