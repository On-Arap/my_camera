import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_camera/screens/preview_cam.dart';

class App extends StatelessWidget {
  final String flavor;

  App({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          visualDensity: VisualDensity.comfortable,
        ),
        home: PreviewCam(flavor: flavor));
  }
}
