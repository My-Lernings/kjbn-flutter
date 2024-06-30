import 'package:app/main.dart';
import 'package:flutter/material.dart';

void showAMessage(String message) {
  ScaffoldMessenger.of(navigatorKey.currentContext!)
      .showSnackBar(SnackBar(content: Text(message)));
}
