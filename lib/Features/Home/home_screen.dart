import 'package:car_alert/Core/Colors.dart';
import 'package:car_alert/Core/Functions.dart';
import 'package:car_alert/Core/Images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../Core/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool pressed = false;
  bool isLoading = false;

  void startMonitoring() {
    setState(() {
      isLoading = true;
      pressed = false;
    });

    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          isLoading = false;
          pressed = true;
        });

        AppFunctions.showWarningDialog(context);
      }
    });
  }

  void stopMonitoring() {
    setState(() {
      isLoading = false;
      pressed = false;
    });
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
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Settings', style: TextStyle(color: Colors.white)),
            ),
            CheckboxListTile(
              title: const Text('Activate Something'),
              value: provider.checkBox1,
              onChanged: provider.setCheckBox1,
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
                Text(
                  "Monitoring Active..",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              else
                Text(
                  "Press to start monitoring",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (pressed || isLoading) {
                    stopMonitoring();
                  } else {
                    startMonitoring();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0A1654),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  pressed || isLoading ? "Stop Monitoring" : "Start Monitoring",
                  style: TextStyle(
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
