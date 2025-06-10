import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../Core/Colors.dart';
import '../../Core/Functions.dart';
import '../../Core/Images.dart';
import '../../Core/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool pressed = false;
  bool isLoading = false;
  final DatabaseReference _alertsRef = FirebaseDatabase.instance.ref().child(
    'alerts',
  );
  StreamSubscription<DatabaseEvent>? _alertSubscription;

  void startMonitoring() {
    setState(() {
      isLoading = true;
      pressed = false;
    });

    // Start listening for new alerts
    _alertSubscription = _alertsRef.onChildAdded.listen((event) {
      final alert = event.snapshot.value as Map<dynamic, dynamic>;
      final message = alert['message'] ?? 'Child detected';
      final age = alert['age'] ?? 'Unknown';
      final timestamp = alert['timestamp'] ?? 'N/A';
      bool wasDismissed = false;

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text('$message (Age: $age, Time: $timestamp)'),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    wasDismissed = true;
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
                onVisible: () {
                  // Reset wasDismissed when SnackBar appears
                  wasDismissed = false;
                },
                behavior: SnackBarBehavior.floating,
              ),
            )
            .closed
            .then((reason) {
              // If SnackBar closed without dismissal (e.g., timed out), show warning dialog
              if (!wasDismissed && mounted && pressed) {
                AppFunctions.showWarningDialog(
                  context,
                  '$message (Age: $age, Time: $timestamp)',
                );
              }
            });
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          isLoading = false;
          pressed = true;
        });

        // Original warning dialog on monitoring start
        //AppFunctions.showWarningDialog(context,'$message (Age: $age, Time: $timestamp)');
      }
    });
  }

  void stopMonitoring() {
    // Cancel Firebase subscription
    _alertSubscription?.cancel();
    _alertSubscription = null;

    setState(() {
      isLoading = false;
      pressed = false;
    });

    // Hide any active SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  void dispose() {
    // Clean up subscription when widget is disposed
    _alertSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(AppAssetsImages.logo, width: 150, fit: BoxFit.cover),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Toggle Theme'),
              trailing: Icon(
                provider.isDark ? Icons.dark_mode : Icons.light_mode,
              ),
              onTap: provider.toggleTheme,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssetsImages.bg),
            fit: BoxFit.contain,
            opacity: 0.1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SpinKitWave(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Colors.deepPurpleAccent
                            : AppColors.primary,
                      ),
                    );
                  },
                )
              else if (pressed)
                const Text(
                  "Monitoring Active..",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              else
                const Text(
                  "Press to start monitoring",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (pressed || isLoading) {
                    stopMonitoring();
                  } else {
                    startMonitoring();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A1654),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  pressed || isLoading ? "Stop Monitoring" : "Start Monitoring",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
