import 'package:flutter/material.dart';

// TODO: add validation

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    Key? key,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Email',
        icon: const Icon(Icons.mail),
      ),
    );
  }
}
