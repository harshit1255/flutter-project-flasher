import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final _audioRecorder = Record();
  final recorder = FlutterSoundRecorder();
  bool button_pressed = false;
  static const onpressed_button_color = Colors.red;
  static const normal_button_color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.flash_on,
              color: button_pressed ? Colors.white : Colors.black,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    button_pressed ? normal_button_color : onpressed_button_color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )),
              ),
              onPressed: () async {
                if (!button_pressed) {
                  await _audioRecorder.start();
                  setState(() {
                    button_pressed = true;
                  });
                  _audioRecorder
                      .onAmplitudeChanged(const Duration(milliseconds: 50))
                      .listen((event) {
                    var amplitude = event;
                    if (amplitude.current >= -20) {
                      TorchLight.enableTorch();
                    } else {
                      TorchLight.disableTorch();
                    }
                  });
                } else {
                  setState((){
                    button_pressed = false;
                  });
                  _audioRecorder.stop();
                }
              },
              child: Text(button_pressed ? 'OFF' : 'ON',
                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
