import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class BoggleAccelerometer extends StatefulWidget {
  const BoggleAccelerometer({super.key});

  @override
  _BoggleAccelerometerState createState() => _BoggleAccelerometerState();
}

class _BoggleAccelerometerState extends State<BoggleAccelerometer> {
  AccelerometerEvent? _accelerometerEvent;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;

  @override
  void initState() {
    super.initState();
    startAccelerometer();
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void startAccelerometer() {
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerEvent = event;
          });
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Erreur"),
                content: const Text("Votre appareil ne dispose pas d'accéléromètre."),
                actions: [
                  ElevatedButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        },
        cancelOnError: true,
      ),
    );
  }

  bool shakeDetected() {
    if (_accelerometerEvent!.x.abs() > 10 ||
        _accelerometerEvent!.y.abs() > 10 ||
        _accelerometerEvent!.z.abs() > 10) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Accelerometer'),
        ),
        Text(_accelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
        Text(_accelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
        Text(_accelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
      ],
    );
  }
}