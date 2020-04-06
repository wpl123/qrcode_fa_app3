// import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import '../../core/services/database_helper.dart';
import '../../ui/shared/device_helper.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/routing_constants.dart';

class LogoutView extends StatefulWidget {
  @override
  _LogoutViewState createState() => _LogoutViewState();
}

    class _LogoutViewState extends State<LogoutView> {// TODO Sort out logout screen, dispose of all the resources

  final log = getLogger('LogoutView');
  DatabaseHelper databaseHelper = DatabaseHelper();

  var backgroundBox = BoxDecoration(
      color: DeviceHelper.appBarColourLight,
      borderRadius: new BorderRadius.all(new Radius.circular(15.0)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Logout'),
      ),
      backgroundColor: DeviceHelper.backgroundColour,
      body: AlertDialog(
          title: new Text("Confirm"),
          content: new Text("Are you sure you want to logout?"),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: new Text("Yes"),
                  onPressed: () {
//
                    Navigator.pop(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (Route<dynamic> route) => false);
                  },
                ),
                FlatButton(
                  child: new Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        )

    );
  }
}
