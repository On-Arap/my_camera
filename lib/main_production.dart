import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:my_camera/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(App(flavor: 'Production', camera: firstCamera));
}
