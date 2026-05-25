import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warungly/firebase_options.dart';
import 'core/auth/auth_state.dart';
import 'screen/home_screen.dart';
import 'screen/login_screen.dart';
import 'screen/splash_page.dart';


void main () async {
   WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthState()..init(),
      child: const MyApp(),
    ),
    
      
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthState>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (_) {
          if (auth.isLoading) {
            return const SplashPage();
          }

          if (auth.isLoggedIn) {
            return const HomeScreen();
          }

          return  LoginScreen();
        },
      ),
    );
  }
}