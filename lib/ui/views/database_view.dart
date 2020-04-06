import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/services/database_helper.dart';
import '../../core/services/HashHelper.dart';
import '../../core/services/user.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/device_helper.dart';
import '../../ui/shared/routing_constants.dart';
import '../../ui/views/side_drawer_view.dart';
import '../../ui/shared/text_styles.dart';

class UserSettingsView extends StatefulWidget {
  @override
  _UserSettingsViewState createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  // AppUser appUser;

  final TextEditingController daysLocalHistoryController =
      TextEditingController()
        ..text = loggedInUserData.daysLocalHistory.toString();
  final TextEditingController daysServerHistoryController =
      TextEditingController()
        ..text = loggedInUserData.daysServerHistory.toString();

  bool isSwitched = (loggedInUserData.serverConnect == 0) ? true : false;
  bool isHist = (loggedInUserData.keepLocalHistory == 0) ? true : false;
  bool isBrowse = (loggedInUserData.inAppBrowsing == 0) ? true : false;
  String isSwitchedStr;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    daysLocalHistoryController.dispose();  // TODO : Dispose of all the controllers
    daysServerHistoryController.dispose();
    super.dispose();
  }

  final log = getLogger('UserSettingsView');

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      resizeToAvoidBottomPadding: false,

//      drawer: SideDrawerView(),
      appBar: AppBar(
        title: Text('QR Code Settings'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(20.0),
//        width: 300.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(" "),
                ),
                Row(
                  children: <Widget>[
                    Text('  Server Connect       ', style: subtitleStyle),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(
                          () {
                            isSwitched = value;
                          },
                        );
                      },
                    ),
                    Expanded(
                        flex: 1,
                        child: isSwitched
                            ? RaisedButton(
                                child: const Text('Options'),
                                color: Colors.green,
                                onPressed: () {
                                  _databaseConnectionView();
                                },
                              )
                            : Container()),
                  ],
                ),
                Row(
                  children: <Widget>[
                    isSwitched
                        ? Text('  Keep Server History               ',
                            style: subtitleStyle)
                        : Container(),
                    Expanded(
                        flex: 1,
                        child: isSwitched
                            ? TextField(
                                maxLength: 3,
                                maxLengthEnforced: true,
                                textAlign: TextAlign.end,
                                decoration: const InputDecoration(
                                  labelText: 'Days:',
                                  hintText: 'No of days',
                                ),
                                controller: daysServerHistoryController,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (newValue) {
                                  loggedInUserData.daysServerHistory = int.parse(
                                      newValue); //TODO: Delete excess History
                                },
                              )
//                        onPressed: () {
//
//                        },
                            : Container()),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Text(" "),
                ),
                Row(
                  children: <Widget>[
                    Text('  Keep Local History ', style: subtitleStyle),
                    Switch(
                      value: isHist,
                      onChanged: (value) {
                        setState(
                          () {
                            isHist = value;
                          },
                        );
                      },
                    ),
                    Expanded(
                        flex: 1,
                        child: isHist
                            ? TextField(
                                maxLength: 3,
                                maxLengthEnforced: true,
                                textAlign: TextAlign.end,
                                decoration: const InputDecoration(
                                  labelText: 'Days:',
                                  hintText: 'No of days',
                                ),
                                controller: daysLocalHistoryController,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (newValue) {
                                  loggedInUserData.daysLocalHistory = int.parse(
                                      newValue); //TODO: Delete excess History
                                },
                              )
                            : Container()),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Text(" "),
                ),
                Row(
                  children: <Widget>[
                    Text('  In App Browsing      ', style: subtitleStyle),
                    Switch(
                      value: isBrowse,
                      onChanged: (value) {
                        setState(
                          () {
                            isBrowse = value;
                          },
                        );
                      },
                    ),
                  ],
                ),
                Expanded(
                  flex: 8,
                  child: Text(" "),
                ),
                FloatingActionButton(
                    child: Text('Done'),
                    onPressed: () {
                      final appUser = AppUser(
                          email: loggedInUserData.email,
                          password: loggedInUserData.password,
                          serverConnect: isSwitched == true ? 0 : 1,
                          serverURL: loggedInUserData.serverURL,
                          keepLocalHistory: isHist == true ? 0 : 1,
                          inAppBrowsing: isBrowse == true ? 0 : 1,
                          field1Label: loggedInUserData.field1Label,
                          field2Label: loggedInUserData.field2Label,
                          field3Label: loggedInUserData.field3Label,
                          daysLocalHistory: loggedInUserData.daysLocalHistory,
                          daysServerHistory:
                              loggedInUserData.daysServerHistory);
                      setState(() {
                        getLogger(
                            "setState: before updateAppUser() ${DateTime.now()}");
                        _updateAppUser(context, appUser);
                      });
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        },
      ),
    );
  }

  _databaseConnectionView() {
    getLogger("_databaseConnectionView button");
    Navigator.pushNamed(
      context,
      DatabaseConnectionViewRoute,
    );
  }

  Future<void> _showSnackBar(BuildContext context, String msg) async {
    getLogger("inside _showSnackBar: before snackbar ${DateTime.now()}");
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 5),
    ); //TODO Snack bar issues - doesn't appear
    Scaffold.of(context).showSnackBar(snackBar);
    getLogger("inside _showSnackBar: after snackbar ${DateTime.now()}");
  }

  Future<void> _updateAppUser(BuildContext context, appUser) async {
    getLogger(
        "inside _updateAppUser: before updateAppUser() for email ${loggedInUserData.email} ${DateTime.now()}");

    var res = await databaseHelper.updateAppUser(appUser);
    getLogger(
        "inside _updateAppUser: after updateAppUser, res $res ${DateTime.now()}");

    loggedInUserData.email = appUser.email;
    loggedInUserData.password = appUser.password;
    loggedInUserData.serverConnect = appUser.serverConnect;
    loggedInUserData.serverURL = appUser.serverURL;
    loggedInUserData.keepLocalHistory = appUser.keepLocalHistory;
    loggedInUserData.inAppBrowsing = appUser.inAppBrowsing;
    loggedInUserData.field1Label = appUser.field1Label;
    loggedInUserData.field2Label = appUser.field2Label;
    loggedInUserData.field3Label = appUser.field3Label;
    loggedInUserData.daysLocalHistory = appUser.daysLocalHistory;
    loggedInUserData.daysServerHistory = appUser.daysServerHistory;

    if (res != 0) {
      _showSnackBar(context, "AppUser updated");
    }
  }
}
