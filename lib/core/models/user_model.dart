import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../core/services/HashHelper.dart';


AppUser appUserFromJson(String str) {
  final jsonData = json.decode(str);
  return AppUser.fromMap(jsonData);
}

String appUserToJson(AppUser data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class AppUser {
  Database database;

  String email;
  String password;
  int serverConnect;
  String serverURL;
  int keepLocalHistory;
  int inAppBrowsing;    // On or off
  String field1Label;
  String field2Label;
  String field3Label;
  int daysLocalHistory;
  int daysServerHistory;
  
 AppUser.dummy() {
        email = "user@youremail.com";
        password = (HashHelper.getHash('123456'));
        serverConnect = 1;   // 0 == True, 1 == False
        serverURL = "progressprogrammingsolutions.com.au/qrcode";
        keepLocalHistory = 1;
        inAppBrowsing = 1;
        field1Label = "Decimal Label ";
        field2Label = "String Label 1";
        field3Label = "String Label 2";
        daysLocalHistory = 30;
        daysServerHistory = 30;
                 
 }

  AppUser({
    this.email,
    this.password,
    this.serverConnect,
    this.serverURL,
    this.keepLocalHistory,
    this.inAppBrowsing,
    this.field1Label,
    this.field2Label,
    this.field3Label,
    this.daysLocalHistory,
     this.daysServerHistory,
  });


  factory AppUser.fromMap(Map<String, dynamic> json) => new AppUser(
        email: json["email"],
        password: json["password"],
        serverConnect: json["serverConnect"],
        serverURL: json["serverURL"],
        keepLocalHistory: json["keepLocalHistory"],
        inAppBrowsing: json["inAppBrowsing"],
        field1Label: json["field1Label"],
        field2Label: json["field2Label"],
        field3Label: json["field3Label"],
        daysLocalHistory: json["daysLocalHistory"],
        daysServerHistory: json["daysServerHistory"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "password": password,
        "serverConnect": serverConnect,
        "serverURL": serverURL,
        "keepLocalHistory": keepLocalHistory,
        "inAppBrowsing": inAppBrowsing,
        "field1Label": field1Label,
        "field2Label": field2Label,
        "field3Label": field3Label,
        "daysLocalHistory": daysLocalHistory,
        "daysServerHistory": daysServerHistory,
      };
}


QRCodeHistory qrcodeHistoryFromJson(String str) {
  final jsonData = json.decode(str);
  return QRCodeHistory.fromMap(jsonData);
}

String qrcodeHistoryToJson(QRCodeHistory data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class QRCodeHistory{

  Database database;  // TODO:  ????
  int     id;
  String  scanDate;
  String  scanTime;
  String  scanQRCode;
  int     scanUsed;
  double  field1;
  String  field2;
  String  field3;

  QRCodeHistory({this.id,
                this.scanDate, 
                this.scanTime, 
                this.scanQRCode, 
                this.scanUsed,
                this.field1,
                this.field2,
                this.field3,
                });

  QRCodeHistory.withID(this.id, 
                this.scanDate, 
                this.scanTime, 
                this.scanQRCode, 
                this.scanUsed,
                this.field1,
                this.field2,
                this.field3,
                );


  factory QRCodeHistory.fromMap(Map<String, dynamic> json) => new QRCodeHistory(
        id: json["id"],
        scanDate: json["scanDate"],
        scanTime: json["scanTime"],
        scanQRCode: json["scanQRCode"],
        scanUsed: json["scanUsed"],
        field1: json["field1"],
        field2: json["field2"],
        field3: json["field3"],
      );

  Map<String, dynamic> toMap() => {
//        "id":         id,
        "scanDate":   scanDate,
        "scanTime":   scanTime,
        "scanQRCode": scanQRCode,
        "scanUsed":   scanUsed,
        "field1":   field1,
        "field2":   field2,
        "field3":   field3,
      };
}



class QRCodeServerHistory{

  Database database;  // TODO:  ????
  String     id;
  String  scanDate;
  String     scanTime;
  String  scanQRCode;
  String     scanUsed;
  double  field1;
  String  field2;
  String  field3;
  

  QRCodeServerHistory({this.id,
                this.scanDate, 
                this.scanTime, 
                this.scanQRCode, 
                this.scanUsed,
                this.field1,
                this.field2,
                this.field3,
                });


factory QRCodeServerHistory.fromMap(Map<String, dynamic> json) => new QRCodeServerHistory(
        id: json["id"],
        scanDate: json["scanDate"],
        scanTime: json["scanTime"],
        scanQRCode: json["scanQRCode"],
        scanUsed: json["scanUsed"],
        field1: json["field1"],
        field2: json["field2"],
        field3: json["field3"],
      );

  Map<String, dynamic> toMap() => {
//        "id":         id,
        "scanDate":   scanDate,
        "scanTime":   scanTime,
        "scanQRCode": scanQRCode,
        "scanUsed":   scanUsed,
        "field1":   field1,
        "field2":   field2,
        "field3":   field3,
        
      };

 QRCodeServerHistory.fromJson1(Map<String, dynamic> json)
    : id = json["id"],
      scanDate = json['scanDate'],
      scanTime = json['scanTime'],
      scanQRCode = json['scanQRCode'],
      scanUsed = json['scanUsed'];

factory QRCodeServerHistory.fromJson(Map<String, dynamic> json) {
    return new QRCodeServerHistory(
        id: json['id'],
        scanDate: json['scanDate'],
        scanTime: json['scanTime'],
        scanQRCode: json['scanQRCode'],
        scanUsed: json['scanUsed'],
        field1: json["field1"],
        field2: json["field2"],
        field3: json["field3"],
      );
  }

  Map<String, dynamic> toJson() =>
    {
      "scanDate":   scanDate,
      "scanTime":   scanTime,
      "scanQRCode": scanQRCode,
      "scanUsed":   scanUsed,
        "field1":   field1,
        "field2":   field2,
        "field3":   field3,
    };
}

class ScanData{

  String scanQRCode;
  int localRowid;
  int serverRowid;
  double  field1;
  String  field2;
  String  field3;

  ScanData ({
    this.scanQRCode,
    this.localRowid,
    this.serverRowid,
    this.field1,
    this.field2,
    this.field3,
    });

}
