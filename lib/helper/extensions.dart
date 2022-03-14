import 'package:flutter/material.dart';

extension Extra on TimeOfDay {
  String formatted() {
    return '$hour:${minute.toString().padLeft(2, '0')}';
  }
}
