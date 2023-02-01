import 'package:flutter/material.dart';
import 'package:squared/screens/preview_cam.dart';

class App extends StatelessWidget {
  final String flavor;

  const App({super.key, required this.flavor});

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
