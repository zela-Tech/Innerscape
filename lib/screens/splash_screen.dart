import 'package:flutter/material.dart';
import 'package:innerscape/core/navigation/auth_nav.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    
    Timer(const Duration(seconds: 2), () {
      //delay before moving to auth screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthNav()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/tree.png', width: 190, fit: BoxFit.contain,), 
        //TODO: replace this with animation logo
      ),
    );
  }
}