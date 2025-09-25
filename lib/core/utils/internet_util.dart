import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/core/utils/network_connection.dart';

Future<void> validateInternet(
  VoidCallback withoutInternet , 
  VoidCallback exeptionControl,
) async {
  final isConected = await NetworkInfoImpl().isConnected;
  if (!isConected) {
    withoutInternet();
  }else{
    exeptionControl();
  }
}

Future<bool> isInternetConected() async {
  final isConected = await NetworkInfoImpl().isConnected;
  return isConected;
}