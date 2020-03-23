import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/services/database_helper.dart';
import '../../core/services/HashHelper.dart';
import '../../core/services/user.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/device_helper.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/views/side_drawer_view.dart';

class DatabaseConnectionView extends StatefulWidget {
  @override
  _DatabaseConnectionViewState createState() => _DatabaseConnectionViewState();
}

class _DatabaseConnectionViewState extends State<DatabaseConnectionView> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  // AppUser appUser;

  final TextEditingController usernameController = TextEditingController()
    ..text = loggedInUserData.email;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController serverController = TextEditingController()
    ..text = loggedInUserData.serverURL;
  final TextEditingController field1LabelController = TextEditingController()
    ..text = loggedInUserData.field1Label;
  final TextEditingController field2LabelController = TextEditingController()
    ..text = loggedInUserData.field2Label;
  final TextEditingController field3LabelController = TextEditingController()
    ..text = loggedInUserData.field3Label;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    serverController.dispose();
    field1LabelController.dispose();
    field2LabelController.dispose();
    field3LabelController.dispose();
    super.dispose();
  }

  final log = getLogger('UserSettingsView');

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        child: Text('Done'),
        onPressed: () {
          getLogger(
              "onPressed: controller ${passwordController.text}, text: ${HashHelper.getHash('123456')}");

          if (usernameController.text != null) {
            loggedInUserData.email = usernameController.text.trim();
          }
          if (passwordController.text != null) {
            loggedInUserData.password =
                HashHelper.getHash((passwordController.text).trim());
          }
          if (serverController.text != null) {
            loggedInUserData.serverURL = serverController.text.trim();
          }
          if (field1LabelController.text != null) {
            loggedInUserData.field1Label = field1LabelController.text.trim();
          }
          if (field2LabelController.text != null) {
            loggedInUserData.field2Label = field2LabelController.text.trim();
          }
          if (field3LabelController.text != null) {
            loggedInUserData.field3Label = field3LabelController.text.trim();
          }
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: Text('Server Connect Options'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(15.0),
//            width: 320.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email:',
                    hintText: 'Enter users email address',
                  ),
                  controller: usernameController,
                  cursorColor: DeviceHelper.appBarColour,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Password:',
                    hintText: 'Enter password',
                  ),
                  controller: passwordController,
                  obscureText: false,
                ),
                TextField(
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Server URL:',
                    hintText: 'Enter the server URL address',
                  ),
                  controller: serverController,
                  obscureText: false,
                ),
                TextField(
                  maxLength: 12,
                  maxLengthEnforced: true,
                  decoration: const InputDecoration(
                    labelText: 'Decimal Input Label:',
                    hintText: 'Enter Decimal Label Name',
                  ),
                  controller: field1LabelController,
                  obscureText: false,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextField(
                        maxLength: 12,
                        maxLengthEnforced: true,
                        decoration: const InputDecoration(
                          labelText: 'String Input Label 1:',
                          //  hintText: 'Enter String Label 1 Name',
                        ),
                        controller: field2LabelController,
                        obscureText: false,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        maxLength: 12,
                        maxLengthEnforced: true,
                        decoration: const InputDecoration(
                          labelText: 'String Input Label 2:',
                          //  hintText: 'Enter String Label 2 Name',
                        ),
                        controller: field3LabelController,
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 8,
                  child: Text(" "),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//      floatingActionButton: Opacity(
//        opacity: keyboardIsOpened ? 0 : 1,
//        child:FloatingActionButton(
//          tooltip: 'Done',
//          child: Text('Done'),
//          onPressed: () {
//                final appUser = AppUser(
//                email: usernameController.text != null
//                    ? usernameController.text
//                    : loggedInUserData.email,
//                password: passwordController.text != null
//                    ? HashHelper.getHash(passwordController.text)
//                    : loggedInUserData.password,
//                serverConnect: isSwitched == true ? 0 : 1,
//                serverURL: serverController.text != null
//                    ? serverController.text
//                    : loggedInUserData.serverURL,
//                keepLocalHistory: isHist == true ? 0 : 1,
//                inAppBrowsing: isBrowse == true ? 0 : 1,
//                );
//            setState(() {
////              getLogger("setState: before updateAppUser() ${DateTime.now()}");
//              _updateAppUser(context, appUser);
//            });
//            Navigator.pop(context);
//
//          }
//        ),
//      ),
//      drawer: SideDrawerView(),
