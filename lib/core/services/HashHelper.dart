import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:hex/hex.dart';

class HashHelper
{
  static String getHash(String plainString)
  {
var bytes = utf8.encode(plainString); // data being hashed

  var digest = sha256.convert(bytes);

  String hashString = HEX.encode(digest.bytes).replaceAll("-", "");
  return hashString;
  }
}

//class Hashdecoder
//{
//  static String getHash(String hashString)
//  {
//var bytes  = HEX.decode(digest.bytes); 
//
//  var digest = sha256.convert(bytes);
//
//  String plainString = utf8.decode(hashString); // data being dehashed
//  return plainString;
//  }
//}