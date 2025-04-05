import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_quest/features/auth/screens/welcome_screen.dart';
import 'package:slice_quest/firebase_options.dart';
import 'package:slice_quest/providers/firebase_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        title: 'Slice Quest',
        home: StreamBuilder(
            stream: ref.read(authProvider).authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    body: Center(
                  child: Text('Logged in'),
                ));
              }
              return WelcomeScreen();
            }));
  }
}
