import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../ui/widgets/login_header.dart';
// import '../../core/services/database_helper.dart';
import '../shared/device_helper.dart';
import '../shared/logger.dart';
import '../shared/routing_constants.dart';
import '../../core/services/user.dart';

//bool _processingLogin = false;

class SideDrawerView extends StatelessWidget {
  SideDrawerView();

  final log = getLogger('SideDrawerView');

  Widget build(BuildContext context) {
    DeviceHelper.initialiseValues(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.camera_enhance),
            title: new Text('Scan', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, ScanViewRoute, arguments: 'Scan');
            },
          ),
          Divider(),
          new ListTile(
            leading: const Icon(Icons.settings),
            title: new Text('Settings', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, UserSettingsViewRoute, arguments: 'Database Edit');
            },
          ),
          Divider(),
          if (loggedInUserData.keepLocalHistory == 0)  // true
            ListTile(
            leading: const Icon(Icons.history),
            title: new Text('History', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, DisplayQRCodeHistoryViewRoute, arguments: 'Local History');
            },            ),
          Divider(),
            if (loggedInUserData.serverConnect == 0)  // true
              ListTile(
              leading: const Icon(Icons.history),
              title: new Text('Server History', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, DisplayServerQRCodeHistoryViewRoute, arguments: 'Server History');
              },),
            Divider(),
          new ListTile(
            leading: const Icon(Icons.share),
            title: new Text('Share', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, ShareViewRoute, arguments: 'Share');
            },
          ),
          Divider(),
          new ListTile(
            leading: const Icon(Icons.info),
            title: new Text('About', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.of(context).pop();
                Navigator.pushNamed(context, AppInfoViewRoute, arguments: 'About');
            },
          ),
          Divider(),
          if (loggedInUserData.serverConnect == 0)  // true
            ListTile(  
            leading: const Icon(Icons.info),
            title: new Text('Logout', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, LogoutViewRoute, arguments: 'Logout');
            },),
          Divider(),
        ],
      ),
    );
  }
}
