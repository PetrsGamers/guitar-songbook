import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/login_screen.dart';
import 'package:guitar_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';
import 'firebase_auth_services.dart';

// placeholder screen, replace with your own screen implementation
class PlaceholderScreen extends ConsumerWidget {
  PlaceholderScreen({super.key, required this.content});
  final User? user = Auth().currentUser;
  final String content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Placeholder screen"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Column(
            children: [
              Text(content),
              Text(user?.email ?? 'nouser'),
              ElevatedButton(
                  onPressed: () {
                    // this is an example route to showcase the stack navigator working
                    // alongside the bottom / rail navbar
                    context.goNamed("Search details");
                  },
                  child: const Text("Push a stack screen (details or sth)")),
              ElevatedButton(
                  onPressed: () async {
                    if (await Auth().signOut() == true) {
                      authController.signOut();
                      context.go('/login');
                    }
                  },
                  child: Text('logout'))
            ],
          ),
        ));
  }
}
