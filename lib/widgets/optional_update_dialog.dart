import 'package:flutter/material.dart';
import 'package:flutter_remote_config_demo/repository/update_repository.dart';

Future<void> showOptionalUpdateDialog(BuildContext context) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(child: Text("Optional Update!!!"),),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("A new version of the app is available."),
            SizedBox(height: 4),
            Text("Would you like to update it Now?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("LATER"),
          ),
          TextButton(
            onPressed: () {
              UpdateRepository().openInPlayStore();
            },
            child: const Text("UPDATE NOW"),
          ),
        ],
      );
    },
  );
}

