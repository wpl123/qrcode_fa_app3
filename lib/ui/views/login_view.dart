import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:qrcode_fa_app3/core/services/user.dart';
import '../../core/services/database_helper.dart';
import '../../ui/shared/device_helper.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/routing_constants.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final log = getLogger('LoginView');
  DatabaseHelper databaseHelper = DatabaseHelper();
//  final TextEditingController _controller = TextEditingController();
  String usernameTypedIn;
  String passwordTypedIn;
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // bool _progressBarActive = false;

  
 // final bool serverConnect = canConnect();
@override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  var backgroundBox = BoxDecoration(
      color: DeviceHelper.appBarColourLight,
      borderRadius: new BorderRadius.all(new Radius.circular(15.0)));

  @override
  Widget build(BuildContext context) {

if (loggedInUserData.email == "user@youremail.com") {
    setState(() {
      usernameController.text = loggedInUserData.email;
  //    passwordController.text = '123456';
    });
   
  }

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Login'),
      ),

      backgroundColor: DeviceHelper.backgroundColour,

      body: Center(
          child: Column(children: <Widget>[
        Expanded(child: Container(), flex: 1),
        Container(
          decoration: backgroundBox,
          padding: EdgeInsets.all(10.0),
          width: 300.0,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Username:", style: TextStyle(color: Colors.grey)),    // TODO Login to the server
                TextField(
                  controller: usernameController,
                  cursorColor: DeviceHelper.appBarColour,
                ),
//                spacer,
                Text("Password:", style: TextStyle(color: Colors.grey)),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                ),
//                spacer,
                Center(
//                 child: buttonOrProgressIndicator,
                    ),
              ]),
        ),
//            _progressBarActive == true? const CircularProgressIndicator() :new Container(),
        Expanded(child: Container(), flex: 4)
      ])),
//
      floatingActionButton: FloatingActionButton(
          child: Text('Login'),
          onPressed: () {
            getLogger("pushprofile: button pushed");
            setState(() {
              usernameTypedIn = usernameController.text;
              passwordTypedIn = passwordController.text;
            });
            getLogger("OnPressed: usernameTypedIn $usernameTypedIn passwordTypedIn $passwordTypedIn");
            pushProfile();

          }),
    );
  }

  pushProfile() async {

        if (usernameTypedIn == null || usernameTypedIn.length == 0) {
      _showDialog("Missing username");

      return;
    }

    String outcome = await databaseHelper.canLogin(usernameTypedIn, passwordTypedIn);

    getLogger("pushprofile: after outcome returned $outcome");
// getAppUserFromServer();

    if (outcome.length > 1) {
      _showDialog(outcome);
      return;
    } // returned " " i.e. == 1 denotes success

    _pushScanPage();
    
   return;
  }

  void _pushScanPage () {

    getLogger("pushprofile: before the Navigator to ScanView");
    Navigator.pop(context);
    Navigator.pushNamed(context, ScanViewRoute, arguments: 'Data Passed in');
  }

  void _showDialog(String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Login Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
