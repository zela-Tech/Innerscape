import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/auth_screen.dart';
import './main_nav.dart';

class AuthNav extends StatelessWidget {
  const AuthNav({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        //user logged in
        if (snapshot.hasData) {
          return const MainNav();
        }

        // Not logged in
        return const AuthScreen();
      },
    );
  }
}