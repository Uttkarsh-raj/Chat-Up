import 'package:chatit/controllers/auth_controller.dart';
import 'package:chatit/view/screens/home_page.dart';
import 'package:chatit/view/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Client client = Client();
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ref.watch(currentUserProvider).when(
          data: (user) {
            if (user != null) {
              return const HomePage();
            }
            return const SignupPage();
          },
          error: (error, st) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )),
    );
  }
}
