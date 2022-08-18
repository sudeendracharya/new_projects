import 'package:flutter/material.dart';

class NotificationDataDisplay extends StatefulWidget {
  NotificationDataDisplay({Key key}) : super(key: key);

  static const routeName = '/NotificationDataDisplay';

  @override
  _NotificationDataDisplayState createState() =>
      _NotificationDataDisplayState();
}

class _NotificationDataDisplayState extends State<NotificationDataDisplay> {
  var cuId = 'data';
  @override
  void didChangeDependencies() {
    cuId = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Text(cuId),
      )),
    );
  }
}
