
//import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// Based on https://www.youtube.com/watch?v=c5CwHXj21xw

//Logger getlogger(String className) {
//  return Logger(printer: SimpleLogPrinter(className));
// }

@override
class SimpleLogPrinter extends LogPrinter {

  final String className;

  SimpleLogPrinter(this.className);


  @override
  //void log(Level level, message, error, StackTrace stackTrace) { // ToDo
    void log(LogEvent event) {

    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];

    println(color('$emoji $className - ${event.message}'));
      print(color('$emoji $className - ${event.message}'));
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}