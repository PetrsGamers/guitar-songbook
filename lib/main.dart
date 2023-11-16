import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/app_navigation.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
