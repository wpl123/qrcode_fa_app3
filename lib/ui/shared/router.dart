import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/services/database_helper.dart';
import '../../ui/shared/logger.dart';
import '../../ui/views/home_view.dart';
import '../../ui/shared/routing_constants.dart';
import '../../ui/views/about_view.dart';
import '../../ui/views/database_view.dart';
import '../../ui/views/database_connection_view.dart';
import '../../ui/views/login_view.dart';
import '../../ui/views/logout_view.dart';
import '../../ui/views/side_drawer_view.dart';
import '../../ui/views/share_view.dart';
import '../../ui/views/qr_scanner_view.dart';
import '../../ui/views/qr_displayer_view.dart';
import '../../ui/views/qr_launcher_view.dart';
import '../../ui/views/qr_history_view.dart';
import '../../ui/views/qr_server_history_view.dart';

// https://www.youtube.com/watch?v=YXDFlpdpp3g

DatabaseHelper databaseHelper = DatabaseHelper();

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => HomeView());
    case LoginViewRoute: 
      return MaterialPageRoute(settings: RouteSettings(name: LoginViewRoute), builder: (context) => LoginView());
     case ScanViewRoute:
      return MaterialPageRoute(builder: (context) => ScanPage());
    case DisplayQRCodeViewRoute:
      var newScanData = settings.arguments as ScanData;
      return MaterialPageRoute(builder: (context) => DisplayQRCodeView(newScanData));
    case LaunchQRCodeViewRoute:
      var newScanData = settings.arguments as ScanData;
            return MaterialPageRoute(builder: (context) => LaunchQRCodeView(newScanData));
    case DatabaseConnectionViewRoute:
      return MaterialPageRoute(builder: (context) => DatabaseConnectionView());
    case DisplayQRCodeHistoryViewRoute:
      return MaterialPageRoute(builder: (context) => DisplayQRCodeHistoryView());
    case DisplayServerQRCodeHistoryViewRoute:
      return MaterialPageRoute(builder: (context) => DisplayServerQRCodeHistoryView());
    case UserSettingsViewRoute:
      return MaterialPageRoute(builder: (context) => UserSettingsView());
    case SideDrawerViewRoute:
      return MaterialPageRoute(builder: (context) => SideDrawerView());
    case AppInfoViewRoute:
      return MaterialPageRoute(builder: (context) => AppInfoView());
    case ShareViewRoute:
      return MaterialPageRoute(builder: (context) => ShareView());
    case LogoutViewRoute:
      return MaterialPageRoute(builder: (context) => LogoutView());
    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(
                name: settings.name,
              ));
  }
}


// HomeView is located in home_view.dart

// LoginView is located in login_view

// ScanPage is located in qr_scanner

// DisplayQRCodeView is located in qr_displayer

// LaunchQRCodeView is located in qr_launcher


class BlankView extends StatelessWidget {
  
  final String name;
  const BlankView({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route for $name is not defined'),
      ),
    );
  }
}
class UndefinedView extends StatelessWidget {
  
  final String name;
  const UndefinedView({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route for $name is not defined'),
      ),
    );
  }
}
