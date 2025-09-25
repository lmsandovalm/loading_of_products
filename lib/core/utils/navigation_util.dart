import 'package:flutter/material.dart';

void navigationPop(BuildContext context, {int quantity = 1}) {
  try {
    for (var i = 0; i < quantity; i++) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  } catch (_) {}
}

void navigateTo(BuildContext context, Widget newScreen) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => newScreen,
    ),
  );
}