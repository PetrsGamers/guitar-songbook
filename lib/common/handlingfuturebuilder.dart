import 'package:flutter/material.dart';

class HandlingFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T?) builder;

  HandlingFutureBuilder({required this.future, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return builder(context, snapshot.data);
        }
      },
    );
  }
}
