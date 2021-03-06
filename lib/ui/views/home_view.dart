import 'package:flutter/material.dart';

import '../../ui/shared/logger.dart';
// import '../../ui/shared/routing_constants.dart';
import '../../ui/widgets/bottom_toolbar.dart';
import '../../ui/views/side_drawer_view.dart';

class HomeView extends StatelessWidget {
  final log = getLogger('HomeView');


  Widget get topSection => Container(
        height: 100.0,
        padding: EdgeInsets.only(bottom: 15.0),
        alignment: Alignment(0.0, 1.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
        //      Text('Following'),
        //      Container(
        //        width: 15.0,
        //      ),
        //      Text(
        //        'For you',
        //        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
        //      ),
            ]),
      );

  Widget get middleSection => Expanded(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
      //      Text("Middle Section VideoDescription(), ActionsToolbar()")
          ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawerView(),
      appBar: AppBar(
        title: Text('QR Code for Fixed Assets'),
      ),
//      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          // Top section
          topSection,

          // Middle expanded
          middleSection,

          // Bottom Section
          BottomToolbar(),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//          child: Text('Login'),
//          onPressed: () {
//            Navigator.pushNamed(context, LoginViewRoute,
//                arguments: 'Data Passed in');
//          }),
    );
  }
}
