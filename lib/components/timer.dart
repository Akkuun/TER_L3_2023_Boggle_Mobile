import 'package:flutter/material.dart';
import 'dart:async';

class BoggleTimer extends StatefulWidget {
  const BoggleTimer({Key? key}) : super(key: key);

  @override
  State<BoggleTimer> createState() {
    return _BoggleTimerState();
  }
}

class _BoggleTimerState extends State<BoggleTimer> {
  int seconds = 0;
  int minutes = 3;
  bool running = false;
  late Timer timer; // late car on ne l'a pas encore initialisé

  /// Initialise le timer
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!running) {
        return;
      }
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
            running = false;
          }
        }
      });
    });
  }

  /// Arrête le timer quand on quitte la page
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  /// Démarre le timer
  void startTimer() {
    setState(() {
      running = true;
    });
  }

  /// Arrête le timer
  void stopTimer() {
    setState(() {
      running = false;
    });
  }

  /// Remet le timer à 3 minutes
  void resetTimer() {
    setState(() {
      seconds = 180;
      minutes = 3;
      running = false;
    });
  }

  /// Met le timer a 0
  void setTimerToZero() {
    setState(() {
      seconds = 0;
      minutes = 0;
      running = false;
    });
  }

  /// Affiche le timer
  String displayTimer() {
    String displaySeconds = seconds.toString();
    String displayMinutes = minutes.toString();
    if (seconds < 10) {
      displaySeconds = '0$seconds';
    }
    return '$displayMinutes:$displaySeconds';
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return Text(
      displayTimer(),
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
