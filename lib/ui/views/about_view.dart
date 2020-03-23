import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
// import '../../core/models/app_info_model.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/views/side_drawer_view.dart';



// admob app ID ca-app-pub-8123200889053393~2305796960
// rewarded unit ID ca-app-pub-8123200889053393/9948197853
// banner unit ID ca-app-pub-8123200889053393/9660369346

// Test ad unit ID ca-app-pub-3940256099942544/5224354917


//class AboutView extends StatefulWidget {
//
//  static AppInfo currentAppInfo;
//
//  @override
//  _AboutViewState createState() => _AboutViewState();
//}
//
//class _AboutViewState extends State<AboutView> {

AppInfoViewState pageState;

class AppInfoView extends StatefulWidget {
  @override
  AppInfoViewState createState() {
    pageState = AppInfoViewState();
    return pageState;
  }
}

class AppInfoViewState extends State<AppInfoView> {
  String appName = "";
  String appID = "";
  String version = "";
  String buildNumber = "";

  @override
  void initState() {
    super.initState();
    getAppInfo();
  }

  final log = getLogger('AboutView');

  void getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      appID = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
//  getLogger("appInfo: ${AboutView.currentAppInfo.appName}");

    return Scaffold(
      drawer: SideDrawerView(),
      appBar: AppBar(
        title: Text('QR Code About'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
//      height: 50.0,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(" "),
            ),
            Text(
              "About: ",
              style: titleStyle,
            ),
            Text(""),
            Text("Progress Programming Solutions P/L", style: subtitleStyle),
            Text(""),
            Text("Appname: $appName", style: subtitleStyle),
            Text("Version: $version", style: subtitleStyle),
            Text("BuildNo: $buildNumber", style: subtitleStyle),
            Expanded(
              flex: 4,
              child: Text(" "),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Text('Done'),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
