import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:qrcode_fa_app3/core/services/user.dart';
import 'package:share/share.dart';
import '../../core/services/database_helper.dart';
import '../../core/models/user_model.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/routing_constants.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/views/side_drawer_view.dart';

class DisplayServerQRCodeHistoryView extends StatefulWidget {
//  DisplayQRCodeHistoryView();

  @override
  _DisplayServerQRCodeHistoryViewState createState() =>
      _DisplayServerQRCodeHistoryViewState();
}

class _DisplayServerQRCodeHistoryViewState extends State<DisplayServerQRCodeHistoryView> {
  final log = getLogger('DisplayServerQRCodeHistoryView');

  Map parsedJsonMap;
  List parsedJsonList;

  DatabaseHelper databaseHelper = DatabaseHelper(); 
  List<QRCodeServerHistory> qrCodeServerHistoryList;
  
  int count = 0;

Future getQRCodeHistoryFromServer() async {

//    var url = 'http://progressprogrammingsolutions.com.au/get_history.php';
    var url = ("http://" + loggedInUserData.serverURL + "/get_history.php");  // TODO: Get certificate 

    getLogger("getQRCodeHistoryFromServer: before post, url, $url");


    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.

      parsedJsonMap = json.decode(response.body);
      setState(() {
        parsedJsonList = parsedJsonMap["history"] as List;
        qrCodeServerHistoryList = parsedJsonList.isNotEmpty ?  parsedJsonList.map((c) => QRCodeServerHistory.fromMap(c)).toList() : [];
      },);

//                      _delete(context, qrCodeHistoryList[_index], _index);
    } else {
        _showErrorSnackBar(context, "Server error ${response.statusCode}");
        throw Exception('Failed to load server history, status code ${response.statusCode}');  // TODO Proper Error handling. 404, Socket Exception
        // error handling --> https://medium.com/flutter-community/handling-network-calls-like-a-pro-in-flutter-31bd30c86be1
  }
}

  @override
  void initState() {
    super.initState();
    getQRCodeHistoryFromServer();
  }

  @override
  Widget build(BuildContext context) {

//    if (qrCodeServerHistoryList == null) {
//      qrCodeServerHistoryList = List<QRCodeServerHistory>(); //instantiate the list
//      updateQRCodeServerHistoryList();
//    }
    return Scaffold(
      drawer: SideDrawerView(),
      appBar: AppBar(
        title: Text('QR Code Server History'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: qrCodeServerHistoryList == null ? 0 : qrCodeServerHistoryList.length,
              padding: EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context, int _index) {
                return Dismissible (
                  key: ValueKey(qrCodeServerHistoryList[_index]),
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerStart,
                    child: Icon(Icons.delete,
                    color: Colors.white,),
                  ),
                  onDismissed: (direction) {
                    getLogger("Dismissable: _index $_index qrCodeServerHistory.id ${qrCodeServerHistoryList[_index].id} ${DateTime.now()}");
                      _deleteQRCodeServerHistory(context, qrCodeServerHistoryList[_index], _index);
                  },
                  child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: GestureDetector(
                    child: CircleAvatar(
                    child: _getAppUsedIcon(qrCodeServerHistoryList[_index].scanQRCode),
                    backgroundColor: _getIconColor(qrCodeServerHistoryList[_index].scanUsed),
                  ),
                  onTap: () {

                    final newScanData = ScanData(
                      scanQRCode: qrCodeServerHistoryList[_index].scanQRCode,
                      localRowid: 0,
                      serverRowid: int.parse(qrCodeServerHistoryList[_index].id)
                    );

                    Navigator.pushNamed(context, LaunchQRCodeViewRoute, arguments: newScanData);
                     // Launch QRCode on screen
                  },
                  ),
                  title: Text("Date: ${qrCodeServerHistoryList[_index].scanTime}, ${qrCodeServerHistoryList[_index].scanDate}", style: titleStyle),
                  subtitle: Text("${qrCodeServerHistoryList[_index].scanQRCode}", style: subtitleStyle),
                  trailing: GestureDetector(
                    child: Icon(Icons.share, color: Colors.grey),
                    onTap: () {
                      getLogger("GestureDector OnTap: _index $_index qrCodeServerHistory.id ${qrCodeServerHistoryList[_index].id} ${DateTime.now()}");
                      _shareDialog(context, qrCodeServerHistoryList[_index]);
                    }),
                ),),);
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
          child: Text('Done'),
          onPressed: () {
            Navigator.of(context).pop(); // pop up the widget tree
          }),
    );
  }

void _delete(BuildContext context, QRCodeHistory qrCodeHistory, int _index){
//
//    getLogger("_delete: qrCodeHistory.id ${qrCodeHistory.id} ${DateTime.now()}");

//    var res = databaseHelper.deleteQRServerCodeHistory(qrCodeHistory.id);
//    if (res != 0) {
//      _showSnackBar(context, "QRCode deleted from scan history", qrCodeHistory, _index);
//      updateQRCodeServerHistoryList();
//      getLogger("_delete: after updateQRCodeHistoryList is called, ${DateTime.now()}");
//    }
  }



Future<void> _deleteQRCodeServerHistory(BuildContext context, QRCodeServerHistory _qrCodeServerHistory, int _index) async {

    // var url = "http://progressprogrammingsolutions.com.au/update_history.php";
    var url = ("http://" + loggedInUserData.serverURL + "/delete_history.php"); //TODO Get Certificate

    getLogger("_updateQRCodeServerHistory: before post, url, $url, serverRowid ${_qrCodeServerHistory.id}");

    var response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
      body: { 
          "scan_id":_qrCodeServerHistory.id,
      }
      );

  getLogger("_deleteQRCodeServerHistory: after post, response.body, ${response.body} runtype ${response.runtimeType}");

    var responseBody = json.decode(response.body);

    getLogger("_deleteQRCodeServerHistory: after json.decode, responseBody, $responseBody, response status, ${response.statusCode}");

    if (response.statusCode != 200) {
        throw Exception('Failed to delete server history, status code ${response.statusCode}');  // TODO Bug - doesn't delete, do error handling
  }
    return;
}




  Icon _getAppUsedIcon(url){

    if (url.startsWith('https')){return Icon(Icons.http);}
    else if (url.startsWith('http')){return Icon(Icons.http);}
    else if (url.startsWith('mailto')){return Icon(Icons.email);}
    else if (url.startsWith('tel')){return Icon(Icons.smartphone);}
    else if (url.startsWith('sms')){return Icon(Icons.sms);}
    else {return Icon(Icons.error_outline);}
  }

  Color _getIconColor(String status) {

    switch (int.parse(status)) {
      case 0: 
        return Colors.grey;
        break;
      case 1: 
        return Colors.green;
        break;
      case 2: 
        return Colors.red;
        break;

      default: return Colors.transparent;
    }
  }

  

  Future<void> updateQRCodeServerHistoryList() async{

    getLogger("inside updateServerQRCodeHistoryList, before getQRCodeHistoryFromServer()");

    Future<List<QRCodeServerHistory>> qrCodeServerHistoryFuture = getQRCodeHistoryFromServer();
    
    getLogger("inside updateServerQRCodeHistoryList, before qrCodeServerHistoryFuture.then");
    
    await qrCodeServerHistoryFuture.then((qrCodeServerHistoryList){

//      getLogger("after then qrCodeHistroyList.last  ${qrCodeServerHistoryList.first.scanQRCode}");

      setState(() {
        this.qrCodeServerHistoryList = qrCodeServerHistoryList;
        this.count = qrCodeServerHistoryList.length;
      });
    });
  }


  void _showSnackBar(BuildContext context, String msg, QRCodeHistory copiedQRCodeHistory, int _index) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
      label: "Undo",
      textColor: Colors.yellow,
      onPressed: () {   // ToDo: Complete Undo https://medium.com/flutter-community/an-in-depth-dive-into-implementing-swipe-to-dismiss-in-flutter-41b9007f1e0
  
//        databaseHelper.newQRCodeHistory(copiedQRCodeHistory);

//        updateServerQRCodeHistoryList();
 
//                _animatedListKey.currentState.insertItem(_index); // ToDo: setup animation
      }
  ),
    );
    Scaffold.of(context).showSnackBar(snackBar)
    .closed
    .then((reason) {
      if (reason != SnackBarClosedReason.action) {
//        updateServerQRCodeHistoryList();
        
      }
    });
    }


void  _shareServerQRCodeHistory(BuildContext context, QRCodeHistory shareQRCodeHistory, String _text) {

    
    String _subject = "Link from ${loggedInUserData.email}";


        Builder(
                  builder: (BuildContext context) {
                    return RaisedButton(
                      child: const Text('Share'),
                      onPressed: _text.isEmpty
                          ? null
                          : () {
                              // A builder is used to retrieve the context immediately
                              // surrounding the RaisedButton.
                              //
                              // The context's `findRenderObject` returns the first
                              // RenderObject in its descendent tree when it's not
                              // a RenderObjectWidget. The RaisedButton's RenderObject
                              // has its position and size after it's built.
                              final RenderBox box = context.findRenderObject();
                              Share.share(_text,
                                  subject: _subject,
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                            },
                    );
                  },
                );
  }


   _shareDialog(BuildContext context, QRCodeServerHistory shareQRCodeServerHistory) {

    final TextEditingController textController = TextEditingController()..text = ("Checkout this link ${shareQRCodeServerHistory.scanQRCode}");
    String _subject = "Link from ${loggedInUserData.email}"; // ToDo: fix null email address

     @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Share"),
          content: Column(
            children: <Widget>[  // ToDo: fix padding --> https://stackoverflow.com/questions/46841637/show-a-text-field-dialog-without-being-covered-by-keyboard
               TextField(
                 controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Share text:',
                    hintText: 'Enter some text and/or link to share',
                  ),
                  maxLines: 2,
//                  onChanged: (String value) => setState(() {
//                    String _text = value;
//                    Navigator.of(context).pop(_text);
//                  }),
                ),
            ],),
          actions: <Widget> [        // usually buttons at the bottom of the dialog    
              Row(
                children: <Widget> [
                  FlatButton(
                    child: Text("Share"),
                    onPressed: () {
                      String _text = textController.text;

                      {
                              // A builder is used to retrieve the context immediately
                              // surrounding the RaisedButton.
                              //
                              // The context's `findRenderObject` returns the first
                              // RenderObject in its descendent tree when it's not
                              // a RenderObjectWidget. The RaisedButton's RenderObject
                              // has its position and size after it's built.
                              final RenderBox box = context.findRenderObject();
                              Share.share(_text,
                                  subject: _subject,
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                            }
       //               _shareQRCodeHistory(context, shareQRCodeHistory, _text);
                   Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                    Navigator.of(context).pop();
                  },
                  ),

                     ]
                    
                  )
          ],
        );
      },
    );
  }

Future<void> _showErrorSnackBar(context, String msg) async {
  getLogger(
        "inside _showErrorSnackBar: before snackbar ${DateTime.now()}");
    final snackBar = SnackBar(content: Text(msg), duration: Duration(seconds: 5),);  //ToDo Snack bar issues - doesn't appear
    Scaffold.of(context).showSnackBar(snackBar);
    getLogger(
        "inside _showSnackBar: after snackbar ${DateTime.now()}");
  }

}