import 'dart:async';
import 'dart:math';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BoggleAccelerometre extends StatefulWidget {

  final ValueNotifier<bool> estSecouer = ValueNotifier<bool>(
      false); // cela permet de récupérer si une secousse a été détectée dans n'importe quelle partie de l'application (car c'est publique dans cette partie de la classe)

  final int fileTaille;
  final double seuilDetection;

  BoggleAccelerometre({super.key, this.fileTaille = 6, this.seuilDetection = 20});

  @override
  BoggleAccelerometreState createState() => BoggleAccelerometreState();
}

class BoggleAccelerometreState extends State<BoggleAccelerometre> {
  AccelerometerEvent? _accelerometerEvent;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool debug = false;
  Queue<double> fileAccel = Queue<double>();
  late int fileTaille;
  late double seuilDetection;

  Duration sensorInterval = SensorInterval.normalInterval;

  @override
  void initState() {
    super.initState();
    fileTaille = widget.fileTaille;
    seuilDetection = widget.seuilDetection;
    startAccelerometre();
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
    widget.estSecouer.value = false;
    fileAccel.clear();
  }

  void startAccelerometre() {
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        // c'est pour écouter les événements de l'accéléromètre (physique)
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerEvent = event;
            widget.estSecouer.value = secousseDetection();
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

  bool secousseDetection() {
    // la magnitude est une mesure de l'intensité totale de l'accélération, indépendamment de la direction pour notre cas
    double x = _accelerometerEvent!.x;
    double y = _accelerometerEvent!.y;
    double z = _accelerometerEvent!.z;

    double magnitude = sqrt(x * x + y * y + z * z);

    fileAccel.add(magnitude);
    if (fileAccel.length > fileTaille) {
      // on garde que les 10 dernières valeurs
      fileAccel.removeFirst();
    }
    if (fileAccel.length < fileTaille) {
      // on attend d'avoir 10 valeurs
      return false;
    }

    double moyMagnitude = fileAccel.reduce((a, b) => a + b) / fileAccel.length;

    if (moyMagnitude < seuilDetection) {
      fileAccel.clear();
      return false;
    }

    if (debug) {
      // ignore: avoid_print
      print('magnitude moyenne: $moyMagnitude');
    }

    return moyMagnitude > seuilDetection;
  }

  @override
  Widget build(BuildContext context) {
    switch (debug) {
      case true:
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Accelerometre'),
            ),
            Text(_accelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
            Text(_accelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
            Text(_accelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
          ],
        );
      case false:
        return const SizedBox.shrink();
    }
  }
}
