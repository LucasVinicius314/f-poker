import 'package:flutter/material.dart';

class DataErrorWidget extends StatelessWidget {
  const DataErrorWidget({
    Key? key,
    this.code,
    this.hasIcon = false,
    this.message = 'Something went wrong.',
  }) : super(key: key);

  final int? code;
  final bool hasIcon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          if (hasIcon)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Icon(
                Icons.warning,
                color: Theme.of(context).disabledColor,
              ),
            ),
          if (code != null)
            Text(
              code.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
