import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BoggleAccelerometer extends StatefulWidget {
  BoggleAccelerometer({super.key});

  final ValueNotifier<bool> isShaking = ValueNotifier<bool>(
      false); // cela permet de récupérer si une secousse a été détectée dans n'importe quelle partie de l'application (car c'est publique dans cette partie de la classe)

  @override
  // ignore: library_private_types_in_public_api
  _BoggleAccelerometerState createState() => _BoggleAccelerometerState();

}

class _BoggleAccelerometerState extends State<BoggleAccelerometer> {
  AccelerometerEvent? _accelerometerEvent;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool debug = false;

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
    _streamSubscriptions.clear();
    widget.isShaking.value = false;
  }

  void startAccelerometer() {
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        // c'est pour écouter les événements de l'accéléromètre (physique)
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerEvent = event;
            widget.isShaking.value = shakeDetected();
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Erreur"),
                  content: const Text(
                      "Votre appareil ne dispose pas d'accéléromètre."),
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
    // la magnitude est une mesure de l'intensité totale de l'accélération, indépendamment de la direction pour notre cas
    double x = _accelerometerEvent!.x;
    double y = _accelerometerEvent!.y;
    double z = _accelerometerEvent!.z;

    double magnitude = sqrt(x * x + y * y + z * z);

    if(debug){
      // ignore: avoid_print
      print('magnitude: $magnitude');
    }

    return magnitude > 20;
  }

  @override
  Widget build(BuildContext context) {
    switch(debug){
      case true:
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
      case false:
        return Container();
    }
  }
}
