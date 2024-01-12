import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/screens/auth/login_screen.dart';
import 'package:guitar_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';
import '../../firebase/firebase_auth_services.dart';

// placeholder screen, replace with your own screen implementation
class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key, required this.content});
  final User? user = Auth().currentUser;
  final String content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    Text("Currently logged in as: ${user?.email ?? 'nouser'}"),
              ),
              ListTile(
                onTap: () async {
                  if (await Auth().signOut() == true) {
                    authController.signOut();
                    context.go('/login');
                  }
                },
                title: const Text('Log out'),
                trailing: const Icon(Icons.logout),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Align content to the bottom

                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("© 2024 All rights reserved 😉"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("created by PetrsGamer and Tejd"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
