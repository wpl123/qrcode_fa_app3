import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/models/user_model.dart';
import '../../core/services/user.dart';
import '../../core/services/database_helper.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/fetch_url_preview.dart';
import '../../ui/shared/routing_constants.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/views/side_drawer_view.dart';

class DisplayQRCodeView extends StatefulWidget {
  final ScanData scanData;
  DisplayQRCodeView(this.scanData);

  @override
  _DisplayQRCodeViewState createState() => _DisplayQRCodeViewState();
}

class _DisplayQRCodeViewState extends State<DisplayQRCodeView> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  final TextEditingController field1Controller = TextEditingController();

  final TextEditingController field2Controller = TextEditingController();

  final TextEditingController field3Controller = TextEditingController();

  bool isSwitched = (loggedInUserData.serverConnect == 0) ? true : false;

  var data;

  final log = getLogger(
      'DisplayQRCodeView'); // TODO: Check version for updating the remote DB on display and launch

  @override
  Widget build(BuildContext context) {
//    print("router.dart DisplayQRCodeView widget.scanData.scanQRCode ${widget.scanData.scanQRCode}");

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: SideDrawerView(),
      floatingActionButton: FloatingActionButton(
          child: loggedInUserData.serverConnect == 0 ? Text('Update') : Text('Launch'), 
          onPressed: () {
            Navigator.pushNamed(context, LaunchQRCodeViewRoute,  // TODO: Skip Launch for ServerConnect
                arguments: widget.scanData); // Launch QRCode on screen
          }),
      appBar: AppBar(
        title: loggedInUserData.serverConnect == 0 ? Text('Data Entry') : Text('QRCode Display'),
      ),
      body: isSwitched
          ? Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
//          decoration: backgroundBox,
                      padding: EdgeInsets.all(10.0),
                      width: 300.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  enabled: isSwitched,
                                  maxLength: 60,
                                  maxLengthEnforced: true,
                                  decoration: InputDecoration(
                                    labelText:
                                        '${loggedInUserData.field1Label}',
                                  ),
                                  controller: field1Controller,
                                  obscureText: false,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  enabled: isSwitched,
                                  maxLength: 60,
                                  maxLengthEnforced: true,
                                  decoration: InputDecoration(
                                    labelText:
                                        '${loggedInUserData.field2Label}',
                                  ),
                                  controller: field2Controller,
                                  obscureText: false,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  enabled: isSwitched,
                                  maxLength: 60,
                                  maxLengthEnforced: true,
                                  decoration: InputDecoration(
                                    labelText:
                                        '${loggedInUserData.field3Label}',
                                  ),
                                  controller: field3Controller,
                                  obscureText: false,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.scanData.scanQRCode}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    QrImage(
                      data: widget.scanData.scanQRCode,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("  "),
                    ),
                  ]),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(flex: 1, child: Text(" ")),
                  QrImage(
                    data: widget.scanData.scanQRCode,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  Expanded(flex: 1, child: Text(" ")),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildPreviewWidget(),
                  ),
                  Expanded(flex: 2, child: Text(" ")),
                ],
              ),
            ),
    );
  }

  _buildPreviewWidget() {
    FetchPreview().fetch(widget.scanData.scanQRCode).then((data) {

      if (mounted) {
        setState(() {
          this.data = data;
        });
      }
      
    });

    if (data == null) {
      return;
    }

    if (data['title'] == "404 Not Found" || data['title'] == "Bad Request") {  //TODO What about Telephones etc
      return Text(widget.scanData.scanQRCode, style: subtitleStyle);           // TODO Create own card  for these  ones
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.green[100],
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(data['image'],
                height: 100, width: 100, fit: BoxFit.cover),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(data['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: 4,
                    ),
                    Text(data['description']),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.scanData.scanQRCode,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
