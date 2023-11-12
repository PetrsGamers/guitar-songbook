import 'package:flutter/material.dart';
import 'package:guitar_app/app_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Guitar App',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        colorScheme: const ColorScheme.dark(primary: Colors.deepOrange),
        useMaterial3: true,
      ),
      //debugShowCheckedModeBanner: false, // remove the DEBUG banner
      routerConfig: AppNavigation.router,
    );
  }
}
