import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qrcode_fa_app3/core/services/user.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/database_helper.dart';
import '../../core/models/user_model.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/routing_constants.dart';

class LaunchQRCodeView extends StatefulWidget {
 
  ScanData scanData; 
  LaunchQRCodeView(this.scanData);

  @override
  _LaunchQRCodeViewState createState() => _LaunchQRCodeViewState();
}

class _LaunchQRCodeViewState extends State<LaunchQRCodeView> {
  DatabaseHelper databaseHelper = DatabaseHelper();

//  String qrInfo = (scanData['scanQRCode']);

  final log = getLogger('LaunchQRCodeView'); 

  _showDialog(String msg, context, ScanData _scanData) {
            // flutter defined function
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Launcher Error"),
                  content: new Text(msg),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Close"),
                      onPressed: () async {
                        await databaseHelper.updateQRCodeHistoryUsed(_scanData.localRowid, 2);
                        Navigator.of(context).pop();    // pop out of error box
                        Navigator.of(context).pop();    // pop up the widget tree
//                        Navigator.pushNamed(context, ScanViewRoute, arguments: 'Data Passed in');
                      },
                    ),
                  ],
                );
              },
            );
          }

   _launchURL(ScanData scanData, context) async {

    if (await canLaunch(scanData.scanQRCode)) {

        if ((loggedInUserData.inAppBrowsing == 0) && (scanData.scanQRCode.startsWith('http'))) {
    
            launch(
            scanData.scanQRCode,
              forceSafariVC: true,
              forceWebView: true,
              enableJavaScript: true,
              enableDomStorage: true,
              headers: <String, String>{'my_header_key': 'my_header_value'},); 
        } else {
            launch(scanData.scanQRCode); 
        }
          

      await databaseHelper.updateQRCodeHistoryUsed(scanData.localRowid, 1);  //ToDo: Update DB with Stocktake data
      await _updateQRCodeServerHistoryUsed(scanData.serverRowid, "1");

      Navigator.of(context).pop();  // pop up the widget tree
//      Navigator.pushNamed(context, ScanViewRoute, arguments: 'Data Passed in');
    } else {
      await databaseHelper.updateQRCodeHistoryUsed(scanData.localRowid, 2);
      await _updateQRCodeServerHistoryUsed(scanData.serverRowid, "2");
      throw _showDialog('Could not launch ${scanData.scanQRCode} on this device', context, scanData);
    }
    return;
  }


Future<void> _updateQRCodeServerHistoryUsed(int _serverRowid, String _scanUsed) async {
    
    // var url = "http://progressprogrammingsolutions.com.au/update_history.php";
    var url = ("http://" + loggedInUserData.serverURL + "/update_history.php"); //TODO Get Certificate

    getLogger("_updateQRCodeServerHistory: before post, url, $url, serverRowid $_serverRowid");

    var response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
      body: { 
          "scan_id":_serverRowid.toString(),
          "scan_used":_scanUsed,
      }
      );

  getLogger("_updateQRCodeServer: after post, response.body, ${response.body} runtype ${response.runtimeType}");

    var responseBody = json.decode(response.body);

    getLogger("_updateQRCodeServer: after json.decode, responseBody, $responseBody, response status, ${response.statusCode}");

    if (response.statusCode != 200) {
        throw Exception('Failed to load server history, status code ${response.statusCode}');
  }
    return;
}

  _launchURLLocal(ScanData scanData, context) async {

    int status;

    if (await canLaunch(scanData.scanQRCode)) {

        if ((loggedInUserData.inAppBrowsing == 0) && (scanData.scanQRCode.startsWith('http'))) {
    
            launch(
            scanData.scanQRCode,
              forceSafariVC: true,
              forceWebView: true,
              enableJavaScript: true,
              enableDomStorage: true,
              headers: <String, String>{'my_header_key': 'my_header_value'},); 
        } else {
            launch(scanData.scanQRCode); 
        }
        
       Navigator.of(context).pop();
       status = 1;  // launch successful
    } else {
      _showDialog('Could not launch ${scanData.scanQRCode} on this device', context, scanData);
    status = 2;
    }
         // launch failed

    await databaseHelper.updateQRCodeHistoryUsed(scanData.localRowid, status);  //ToDo: Update DB with Stocktake data
//  await _updateQRCodeServerHistoryUsed(scanData.serverRowid, status);
}
@override
Widget build(BuildContext context) {

//  _launchURL(widget.scanData, context);
  // 1. launch URL if serverConnect == 1;

  if (loggedInUserData.serverConnect == 1) {
    _launchURLLocal(widget.scanData, context);
  }

  // 3. update the remote database if serverConnect == 0;

  return Container();
  }
}
