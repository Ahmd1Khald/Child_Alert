import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AppFunctions {
  static void showWarningDialog(BuildContext context, String msg) {
    bool dismissed = false;

    // Start timer
    Future.delayed(Duration(seconds: 5), () async {
      if (!dismissed) {
        final message = Uri.encodeComponent(msg);
        final whatsappUrl = Uri.parse("https://wa.me/?text=$message");

        sendAlertMessage(msg);
        //playAlert();
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Warning"),
        content: Text(
          "EMERGENCY! A child has been detected inside the car – check immediately!",
        ),
        actions: [
          TextButton(
            onPressed: () {
              dismissed = true;
              //pauseAlert();
              Navigator.of(context).pop();
            },
            child: Text("Go Back"),
          ),
        ],
      ),
    );
  }

  static void sendAlertMessage(String msg) {
    Share.share('EMERGENCY! $msg\n from CarAngle app', subject: '');
  }

  //static final assetsAudioPlayer = AssetsAudioPlayer();

  // static Future<void> playAlert() async {
  //   try {
  //     // Load the audio file from assets
  //     await assetsAudioPlayer
  //         .open(Audio("assets/sounds/alert.mp3"))
  //         .then((value) {});
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  //
  // static Future<void> pauseAlert() async {
  //   try {
  //     // Load the audio file from assets
  //     await assetsAudioPlayer.stop();
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
}
