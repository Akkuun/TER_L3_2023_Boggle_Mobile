import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';

class BoggleTimer extends StatefulWidget {
  const BoggleTimer({Key? key}) : super(key: key);

  @override
  State<BoggleTimer> createState() => _BoggleTimerState();
}

class _BoggleTimerState extends State<BoggleTimer> {
  int seconds = 180;
  int minutes = 3;
  bool running = false;
  Timer? timer; //? pour pas qu'il soit null

  /// Démare le timer
  void startTimer() {
    setState(() {
      running = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
            timer.cancel();
            running = false;
          }
        }
      });
    });
  }

  /// Arrête le timer
  void stopTimer(){
    setState(() {
      running = false;
    });
    timer?.cancel();
  }

  /// Remet le timer à 3 minutes
  void resetTimer(){
    setState(() {
      seconds = 180;
      minutes = 3;
      running = false;
    });
  }

  /// Met le timer a 0
  void setTimerToZero(){
    setState(() {
      seconds = 0;
      minutes = 0;
      running = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
