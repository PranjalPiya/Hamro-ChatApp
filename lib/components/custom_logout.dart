import 'package:flutter/material.dart';

void logoutComponent({BuildContext? context, void Function()? onPressed}) {
  showDialog(
      context: context!,
      builder: (context) => Center(
              child: AlertDialog(
            title: const Text('Logout'),
            actions: [
              TextButton(
                onPressed: onPressed,
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.inversePrimary),
                  )),
            ],
          )),
      barrierDismissible: true);
}
