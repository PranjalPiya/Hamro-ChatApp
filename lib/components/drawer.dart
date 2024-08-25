import 'package:chatapp/auth/auth_services.dart';
import 'package:flutter/material.dart';

final authServices = AuthServices();
Widget appDrawer({BuildContext? context, void Function()? onTap}) {
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context!).colorScheme.primary),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    authServices.getCurrentUser()?.displayName?.toUpperCase() ??
                        'U S E R',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2),
                  ),
                  Text(
                    authServices.getCurrentUser()!.email!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2),
                  ),
                ],
              ),
            )),
        ListTile(
          title: Text(
            'S E T T I N G',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        ListTile(
          title: Text(
            'L O G O U T',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: onTap,
        ),
      ],
    ),
  );
}
