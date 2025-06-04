import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Core/theme_provider.dart';
import 'Features/Splash/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Child Alert',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
      ),
      home: const SplashScreen(),
    );
  }
}
