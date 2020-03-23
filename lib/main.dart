//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
//import './core/services/user.dart';
import './ui/shared/device_helper.dart';
import './ui/shared/logger.dart';
import './ui/shared/router.dart';
import './ui/shared/routing_constants.dart';

//...
void main() async {

   Logger.level = Level.info;

  WidgetsFlutterBinding.ensureInitialized();

  String _defaultRoute;

   await databaseHelper.getServerConnect().then((value) {     
        if (value == false) {
        _defaultRoute = ScanViewRoute;
        
      } else {
         _defaultRoute = LoginViewRoute;
      }
  });

  runApp(MyApp(_defaultRoute));
} 


class MyApp extends StatefulWidget {
  final String _defaultRoute;
  MyApp(this._defaultRoute);

    @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  
  final log = getLogger('_MyAppState');

  @override
  
  void initState() {

    super.initState();

//    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-8123200889053393~2305796960');

//    Ads.init('ca-app-pub-8123200889053393~2305796960', testing: true);

//    Ads.showBannerAd();
  }

  @override
  
  void dispose() {
//    Ads.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter QR Reader Tutorial',
//      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      onGenerateRoute: generateRoute,
      initialRoute: widget._defaultRoute,    // LoginViewRoute
    );
  }
}

