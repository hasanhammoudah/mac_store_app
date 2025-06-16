import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/views/screens/authentication_screen/login_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");


  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  // Stripe.publishableKey =
  //     "pk_test_51RQOn0D8KrVmmdOIs9g10RXbwv61qgNaCdIh5gX4Gsqqw0entb7420V1HiUJHQ1BAhtZPK3VcibfzDQVS9vY3Xzi00ERG5KFsL";
  await Stripe.instance.applySettings();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  //Method to check the token and set the user data if token is available
  Future<void> _checkTokenAndSetUser(WidgetRef ref, context) async {
    await AuthController().getUserData(context, ref);

    ref.watch(userProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          return FutureBuilder(
              future: _checkTokenAndSetUser(ref, context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final user = ref.watch(userProvider);
                return user!.token.isNotEmpty ? MainScreen() : const LoginScreen();
              });
        }
      ),
    );
  }
}
