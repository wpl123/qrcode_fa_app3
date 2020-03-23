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
      body: Center(
        child: Column(),
      ),
      floatingActionButton: FloatingActionButton(
          child: Text('Logout'),
          onPressed: () {
            logout();
          }),
    );
  }

  logout() {
    _showDialog("Are you sure you want to logout?");
  }

  void _showDialog(String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Row(
              children: <Widget>[
                FlatButton(
                  child: new Text("Yes"),
                  onPressed: () {
                    databaseHelper.closeDB();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, LoginViewRoute,
                        arguments: 'Logged out');
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
        );
      },
    );
  }
}
