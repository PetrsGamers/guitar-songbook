import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// placeholder screen, replace with your own screen implementation
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.content});

  final String content;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Placeholder screen"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Column(
            children: [
              Text(content),
              ElevatedButton(
                  onPressed: () {
                    // this is an example route to showcase the stack navigator working
                    // alongside the bottom / rail navbar
                    context.goNamed("Search details");
                  },
                  child: const Text("Push a stack screen (details or sth)"))
            ],
          ),
        ));
  }
}
