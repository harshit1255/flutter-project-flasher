import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record/record.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 0;
  final _audioRecorder = Record();
  final recorder = FlutterSoundRecorder();
  bool permission = false;
  void _incrementCounter(value) {
    setState(() {
      _counter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  if (!permission) {
                    await _audioRecorder.start();
                    setState(() {
                      permission = true;
                    });
                    await _audioRecorder
                        .onAmplitudeChanged(Duration(milliseconds: 50))
                        .listen((event) {
                      var a = event;
                      if (a.current >= -20) {
                        TorchLight.enableTorch();
                      } else {
                        TorchLight.disableTorch();
                      }
                      _incrementCounter(a.current);
                    });
                  } else {
                    permission = false;
                    _audioRecorder.stop();
                  }
                },
                child: const Icon(Icons.start)),
            Text('$_counter')
          ],
        ),
      ),
    );
  }
}
