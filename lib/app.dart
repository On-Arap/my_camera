import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

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
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  setupCameras() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.ultraHigh);

      controller!.setFlashMode(FlashMode.off);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  @override
  void initState() {
    setupCameras();

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        body: Container(
          child: controller == null
              ? const Center(child: Text("Loading Camera..."))
              : !controller!.value.isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : CameraPreview(controller!),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final image = await controller!.takePicture();
              print("if mounted");
              if (!mounted) return;
              print("mounted");
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    image: image,
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

class DisplayPictureScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureScreen({super.key, required this.image});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String buttonText = "Save Image";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      //body: const Center(child: Text("image")),
      body: Column(
        children: [
          TextButton(onPressed: () => GallerySaver.saveImage(widget.image.path, albumName: "Squared"), child: Text(buttonText)),
          Image.file(File(widget.image.path)),
        ],
      ),
    );
  }
}
