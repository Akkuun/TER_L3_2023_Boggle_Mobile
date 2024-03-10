import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class BoggleTimer extends StatefulWidget {
  const BoggleTimer({super.key});

  @override
  State<BoggleTimer> createState() {
    return _BoggleTimerState();
  }
}

class _BoggleTimerState extends State<BoggleTimer> {
  int seconds = 0;
  int minutes = 3;
  bool running = false;
  double? progression;
  late Timer timer; // late car on ne l'a pas encore initialisé
  bool debug = false;

  /// Initialise le timer
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void _timerCallBack(Timer t) {
    TimerServices timerServices =
        Provider.of<TimerServices>(context, listen: false);
    if (!running) {
      return;
    }
    setState(() {
      if (seconds > 0) {
        seconds--;
        progression = timerServices.getTimerProgress();
        timerServices.update(seconds, minutes, progression!);
      } else {
        if (minutes > 0) {
          minutes--;
          seconds = 59;
          progression = timerServices.getTimerProgress();
          timerServices.update(seconds, minutes, progression!);
        } else {
          timerServices.stop();
          Provider.of<GameServices>(context, listen: false).stop();
        }
      }
    });
    // Ajoutez cette ligne pour le débogage
  }

  /// Arrête le timer quand on quitte la page
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  /// Démarre le timer
  void startTimer() {
    if (!running) {
      setState(() {
        running = true;
        timer = Timer.periodic(const Duration(seconds: 1), _timerCallBack);
      });
    }
  }

  /// Arrête le timer

  void stopTimer() {
    if (running) {
      setState(() {
        running = false;
        timer.cancel();
      });
    }
  }

  /// Affiche le timer
  String displayTimer() {
    String displaySeconds = seconds.toString();
    String displayMinutes = minutes.toString();
    //String displayProgression = progression.toString();

    if (seconds < 10) {
      displaySeconds = '0$seconds';
    }

    return '$displayMinutes:$displaySeconds';
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<GameServices>().triggerPopUp) {
      stopTimer();
    } else {
      startTimer();
    }

    return Text(
      displayTimer(),
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
