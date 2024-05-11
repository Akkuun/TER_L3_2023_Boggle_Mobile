import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class BoggleTimerMulti extends StatefulWidget {
  const BoggleTimerMulti({super.key});

  @override
  State<BoggleTimerMulti> createState() {
    return _BoggleTimerStateMulti();
  }
}

class _BoggleTimerStateMulti extends State<BoggleTimerMulti> {
  bool running = false;
  double? progression;
  late Timer timer; // late car on ne l'a pas encore initialisé
  bool debug = false;
  DateTime endDate = DateTime.now();
  int seconds = 0;
  int minutes = 3;

  /// Initialise le timer
  @override
  void initState() {
    super.initState();
    //Provider.of<GameServices>(context, listen: false).start();

    startTimer();
  }

  void _timerCallBack(Timer t) {
    TimerServices timerServices =
        Provider.of<TimerServices>(context, listen: false);

    if (!running) {
      return;
    }
    setState(() {
      if (endDate.isBefore(DateTime.now()) && running) {
        running = false;

        timerServices.stop();
        Provider.of<GameServices>(context, listen: false).stop();
      } else {
        final difference = endDate.difference(DateTime.now());
        seconds = difference.inSeconds % 60;
        minutes = difference.inMinutes % 60;
        progression = 1 - (minutes * 60 + seconds) / (60 * 3);

        timerServices.update(seconds, minutes, progression!);
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
        endDate = DateTime.fromMillisecondsSinceEpoch(
            Provider.of<RealtimeGameProvider>(context, listen: false)
                .game['end_time']);
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
    return Text(
      displayTimer(),
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
