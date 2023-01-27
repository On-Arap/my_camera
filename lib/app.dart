import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class App extends StatelessWidget {
  final String flavor;
  App({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome(flavor: flavor));
  }
}

class MyHome extends StatefulWidget {
  final String flavor;
  const MyHome({super.key, required this.flavor});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late CameraController _controller;

  Future<void> _setupCameras() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );
    _controller.setFlashMode(FlashMode.off);
  }

  @override
  void initState() {
    _setupCameras();

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        body: FutureBuilder<void>(
          future: _controller.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final image = await _controller.takePicture();
              print("if mounted");
              if (!mounted) return;
              print("mounted");
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    imagePath: image.path,
                  ),
                ),
              );
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    print("IMAGE");
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: const Center(
          child: Text(
        "image",
      )),
      // body: Image.file(File(path: imagePath)),
    );
  }
}
