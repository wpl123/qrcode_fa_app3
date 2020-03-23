import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrcode_fa_app3/core/services/user.dart';
import 'package:share/share.dart';
import '../../core/services/database_helper.dart';
import '../../core/models/user_model.dart';
import '../../ui/shared/logger.dart';
import '../../ui/shared/routing_constants.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/views/side_drawer_view.dart';

class DisplayQRCodeHistoryView extends StatefulWidget {
//  DisplayQRCodeHistoryView();

  @override
  _DisplayQRCodeHistoryViewState createState() =>
      _DisplayQRCodeHistoryViewState();
}

class _DisplayQRCodeHistoryViewState extends State<DisplayQRCodeHistoryView> {
  final log = getLogger('DisplayQRCodeHistoryView');

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<QRCodeHistory> qrCodeHistoryList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    updateQRCodeHistoryList();
  }

  @override
  Widget build(BuildContext context) {

  //  if (qrCodeHistoryList == null) {
  //    qrCodeHistoryList = List<QRCodeHistory>(); //instantiate the list
  //    updateQRCodeHistoryList();
  //  }

    return Scaffold(
      drawer: SideDrawerView(),
      appBar: AppBar(
        title: Text('QR Code for Fixed Assets'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              padding: EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context, int _index) {
                return Dismissible (
                  key: ValueKey(qrCodeHistoryList[_index]),
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerStart,
                    child: Icon(Icons.delete,
                    color: Colors.white,),
                  ),
//                  secondaryBackground: Container(
//                  color: Colors.blue,
//                  padding: EdgeInsets.symmetric(horizontal: 20),
//                  alignment: AlignmentDirectional.centerEnd,
//                  child: Icon(
//                    Icons.archive,
//                    color: Colors.white,
//                  ),
//                ),

                  onDismissed: (direction) {
                    getLogger("Dismissable: _index $_index qrCodeHistory.id ${qrCodeHistoryList[_index].id} ${DateTime.now()}");
                      _delete(context, qrCodeHistoryList[_index], _index);
                  },
                  child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: GestureDetector(
                    child: CircleAvatar(
                    child: _getAppUsedIcon(qrCodeHistoryList[_index].scanQRCode),
                    backgroundColor: _getIconColor(qrCodeHistoryList[_index].scanUsed),
                  ),
                  onTap: () {

                    final newScanData = ScanData(
                      scanQRCode: qrCodeHistoryList[_index].scanQRCode,
                      localRowid: qrCodeHistoryList[_index].id,
                      serverRowid: 0
                    );

                    Navigator.pushNamed(context, LaunchQRCodeViewRoute, arguments: newScanData);  // Launch QRCode on screen
                  },
                  ),
                  title: Text("Date: ${qrCodeHistoryList[_index].scanTime}, ${qrCodeHistoryList[_index].scanDate}", style: titleStyle),
                  subtitle: Text("${qrCodeHistoryList[_index].scanQRCode}", style: subtitleStyle),
                  trailing: GestureDetector(        // ToDo: Change to share link
                    child: Icon(Icons.share, color: Colors.grey),
                    onTap: () {
                      getLogger("GestureDector OnTap: _index $_index qrCodeHistory.id ${qrCodeHistoryList[_index].id} ${DateTime.now()}");
                      _shareDialog(context, qrCodeHistoryList[_index]);
                    }),
//                  onTap:() {
//                    getLogger("_DisplayQRCodeHistoryViewState: ListTile Tapped");
//                  }
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

  void _showSnackBar(BuildContext context, String msg, QRCodeHistory copiedQRCodeHistory, int _index) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
      label: "Undo",
      textColor: Colors.yellow,
      onPressed: () {   // ToDo: Complete Undo https://medium.com/flutter-community/an-in-depth-dive-into-implementing-swipe-to-dismiss-in-flutter-41b9007f1e0
  
        databaseHelper.newQRCodeHistory(copiedQRCodeHistory);

        updateQRCodeHistoryList();
 
//                _animatedListKey.currentState.insertItem(_index); // ToDo: setup animation
      }
  ),
    );
    Scaffold.of(context).showSnackBar(snackBar)
    .closed
    .then((reason) {
      if (reason != SnackBarClosedReason.action) {
        updateQRCodeHistoryList();
        
      }
    });
    }


  void _delete(BuildContext context, QRCodeHistory qrCodeHistory, int _index){

    getLogger("_delete: qrCodeHistory.id ${qrCodeHistory.id} ${DateTime.now()}");

    var res = databaseHelper.deleteQRCodeHistory(qrCodeHistory.id);
    if (res != 0) {
      _showSnackBar(context, "QRCode deleted from scan history", qrCodeHistory, _index);
      updateQRCodeHistoryList();
      getLogger("_delete: after updateQRCodeHistoryList is called, ${DateTime.now()}");
    }
  }

  Icon _getAppUsedIcon(url){

    if (url == null){return Icon(Icons.error_outline);}
    else if (url.startsWith('https')){return Icon(Icons.http);}
    else if (url.startsWith('http')){return Icon(Icons.http);}
    else if (url.startsWith('mailto')){return Icon(Icons.email);}
    else if (url.startsWith('tel')){return Icon(Icons.smartphone);}
    else if (url.startsWith('sms')){return Icon(Icons.sms);}
    else {return Icon(Icons.error_outline);}
  }

  Color _getIconColor(status) {

    switch (status) {
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

  void updateQRCodeHistoryList(){

    Future<List<QRCodeHistory>> qrCodeHistoryFuture = databaseHelper.getAllQRCodeHistorys();
    
    qrCodeHistoryFuture.then((qrCodeHistoryList){

      setState(() {
        this.qrCodeHistoryList = qrCodeHistoryList;
        this.count = qrCodeHistoryList.length;
      });
    });
  }

void  _shareQRCodeHistory(BuildContext context, QRCodeHistory shareQRCodeHistory, String _text) {

    
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


   _shareDialog(BuildContext context, QRCodeHistory shareQRCodeHistory) {

    final TextEditingController textController = TextEditingController()..text = ("Checkout this link ${shareQRCodeHistory.scanQRCode}");
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

}