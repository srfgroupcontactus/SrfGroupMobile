import 'package:flutter/material.dart';
import 'package:my_app/src/modules/notification/screens/notifications_scroll.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          backgroundColor: Colors.amber,
        ),
        body: NotificationsScrollPaginator()
    );
  }

}
