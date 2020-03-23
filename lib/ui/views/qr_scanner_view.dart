import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/services/database_helper.dart';
import '../../core/services/user.dart';
import '../../core/models/user_model.dart';
import '../../ui/shared/qr_mobile_vision/qr_camera.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/routing_constants.dart';
import '../../ui/views/side_drawer_view.dart';


class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrInfo = 'Scan a Code';
  bool _camState = false;
//  int localRowid = 0;
//  int serverRowid = 0;
  int serverRowidFuture = 0;
  int localRowidFuture = 0;


   DatabaseHelper databaseHelper = DatabaseHelper();

  final log = getLogger('_ScanPageState');

  _scanCode() {
  
    if (mounted) {
      setState(() {
      _camState = true;
     });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawerView(),
      appBar: AppBar(
        title: Text('QR Code for Fixed Assets'),
      ),
      body: _camState
          ? Center(
              child: SizedBox(
                width: 512,
                height: 1024,
                child: QrCamera(
                  onError: (context, error) => Text(
                    error.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                  qrCodeCallback: (code) {
                    _qrCallback(code);
                  },
                ),
              ),
            )
          : Center(
              child: Text ("Scan QRcode or Barcode"),
                ),
      floatingActionButton: Visibility(
        visible: !_camState,
        child: FloatingActionButton(
          onPressed: _scanCode,
          tooltip: 'Scan',
          child: Text('Scan'),  // Icon(Icons.scanner),
        ),
      ),
    );
  }

  _qrCallback(String url) async{
    if (mounted) {
      setState(() {
      _camState = false;
      qrInfo = url;
     
//      Navigator.of(context).pop();
    });
    }
    

//    getLogger ("_qrCallback: after setState, (before insertHistory)");
    var newScanData = await  _insertHistory(url);

//    getLogger ("_qrCallback (before pop)  newScanData ${newScanData.scanQRCode}, localRowid ${newScanData.localRowid}, serverRowid ${newScanData.serverRowid}");
    Navigator.pop(context);
//    getLogger ("_qrCallback (after pop)  newScanData ${newScanData.scanQRCode}, localRowid ${newScanData.localRowid}, serverRowid ${newScanData.serverRowid}");
    Navigator.pushNamed(context, DisplayQRCodeViewRoute, arguments: newScanData);  // Display QRCode on screen
    
 
  }

 Future<ScanData> _insertHistory(String url) async {

    String _scanDate = formatDate(DateTime.now(), [dd, ".", mm, ".", yyyy]);
    String _scanTime = formatDate(DateTime.now(), [HH, ":", nn, ":", ss]);
    String _scanQRCode = url;
    int _scanUsed = 0;
   

     if (loggedInUserData.keepLocalHistory == 0) {
      localRowidFuture = await _insertLocalHistory(_scanDate, _scanTime, _scanQRCode, _scanUsed);
     }
    if (loggedInUserData.serverConnect == 0) {
      serverRowidFuture = await _insertServerHistory(_scanDate, _scanTime, _scanQRCode, _scanUsed.toString());
    }


    getLogger ("_insertHistory  _scanQRCode $_scanQRCode, localRowid $localRowidFuture, serverRowid $serverRowidFuture");

    final newScanData = ScanData(
        scanQRCode: _scanQRCode,
        localRowid: localRowidFuture.toInt(),
        serverRowid: serverRowidFuture,     //(loggedInUserData.serverConnect == 0 ? serverRowid : 0),
      );
    return newScanData;
 
  }



Future<int> _insertLocalHistory(String _scanDate, String _scanTime, String _scanQRCode, int _scanUsed) async {

    
    final newQRCodeHistory = QRCodeHistory(
          scanDate: _scanDate,
          scanTime: _scanTime,
          scanQRCode: _scanQRCode,
          scanUsed: _scanUsed
          );

     
    var localRowid = await databaseHelper.newQRCodeHistory(newQRCodeHistory);

//      getLogger ("insertLocalHistory  localRowid $localRowid type ${localRowid.runtimeType}");
    return localRowid;
  }

Future<int>  _insertServerHistory(String _scanDate, String _scanTime, String _scanQRCode, String _scanUsed) async {

    //var url = "http://progressprogrammingsolutions.com.au/insert_history.php";
    var url = ("http://" + loggedInUserData.serverURL + "/insert_history.php");  // TODO: Get certificate 

    getLogger("_insertServerHistory: before post, url, $url");

    var response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
      body: { 
          "scan_date":_scanDate,
          "scan_time":_scanTime,
          "scan_qrcode":_scanQRCode,
          "scan_used":_scanUsed,
      }
      );

  getLogger("_insertServerHistory: after post, response.body, ${response.body}");

    var responseBody = await json.decode(response.body);

    getLogger("_insertServerHistory: after json.decode, responseBody, $responseBody, response status, ${response.statusCode}");

    if (response.statusCode != 200) {
        throw Exception('Failed to load server history, status code ${response.statusCode}');
  }

    return int.parse(responseBody);
  }
}
