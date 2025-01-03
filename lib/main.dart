import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/views/screens/authentication_screen/login_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  //Method to check the token and set the user data if token is available
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Retrive the authentication token and user data stored locally
    String? token = prefs.getString('auth_token');
    String? userJson = prefs.getString('user');
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    } else {
      ref.read(userProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: _checkTokenAndSetUser(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = ref.watch(userProvider);
            return user != null ? MainScreen() : const LoginScreen();
          }),
    );
  }
}
