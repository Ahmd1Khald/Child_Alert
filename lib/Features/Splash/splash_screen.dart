// splash_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';

import '../Home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _size = 100;

  @override
  void initState() {
    super.initState();

    // Start animation after short delay
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
        _size = 200;
      });
    });

    // Navigate to home screen after delay
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            width: _size,
            height: _size,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}
