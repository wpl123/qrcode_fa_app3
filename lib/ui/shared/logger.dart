import 'package:logger/logger.dart';
import './log_printer.dart';

// Based on https://www.youtube.com/watch?v=c5CwHXj21xw

Logger getLogger(String className) {
  print ("Classname: $className");
  return Logger(printer: SimpleLogPrinter(className));
}
