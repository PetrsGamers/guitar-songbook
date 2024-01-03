import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/app_navigation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firebase/auth_notifier.dart';
import 'firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
}

final authProvider = ChangeNotifierProvider((ref) => AuthController());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        colorScheme: const ColorScheme.dark(primary: Colors.deepOrange),
        useMaterial3: true,
      ),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
