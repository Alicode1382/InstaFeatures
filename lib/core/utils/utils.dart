import 'package:flutter/material.dart';

class Utils{
    static void logWarning(String msg) {
    debugPrint('\x1B[33m$msg\x1B[0m');
  }
}