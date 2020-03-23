import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:package_info/package_info.dart';
//
////import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';
//import '../../core/models/user_model.dart';
//import '../../core/services/HashHelper.dart';
//import '../../core/services/user.dart';
//import '../../ui/shared/logger.dart';

class AppInfo {
  String appName;
  String packageName;
  String version;
  String buildNumber;


  AppInfo({
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber
  });
}