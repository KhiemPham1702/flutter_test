import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_flutter/firebase_options.dart';
import 'package:test_flutter/providers/auth_provider.dart';
import 'package:test_flutter/screens/home_screen.dart';
import 'package:test_flutter/screens/start_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user != null ? HomeScreen() : StartScreen(),
    );
  }
}
