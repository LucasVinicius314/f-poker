import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showDefaultSnackBar({
  required BuildContext context,
  required String content,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
