import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade900,
      content: Text(errorMessage, textAlign: TextAlign.center),
    ),
  );
}
