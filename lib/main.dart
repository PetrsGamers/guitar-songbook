import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/common/app_theme.dart';
import 'package:guitar_app/common/navigation/app_navigation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firebase/auth_notifier.dart';
import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

final authProvider = ChangeNotifierProvider((ref) => AuthController());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: CustomAppTheme.darkOrangeTheme(),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
