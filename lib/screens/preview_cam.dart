import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:squared/screens/display_photo.dart';

class PreviewCam extends StatefulWidget {
  final String flavor;
  const PreviewCam({super.key, required this.flavor});

  @override
  State<PreviewCam> createState() => _PreviewCamState();
}

class _PreviewCamState extends State<PreviewCam> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  setupCameras() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(
        cameras![0],
        ResolutionPreset.ultraHigh,
      );

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          controller!.setFlashMode(FlashMode.off);
          controller!.setZoomLevel(1.1);
        });
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
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          Expanded(
            child: Container(
                child: controller == null
                    ? const Center(child: Text("Loading Camera..."))
                    : !controller!.value.isInitialized
                        ? const Center(child: CircularProgressIndicator())
                        : Center(
                            child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipRect(
                              child: Transform.scale(
                                scale: controller!.value.aspectRatio / 1,
                                child: Center(
                                  child: CameraPreview(controller!),
                                ),
                              ),
                            ),
                          ))
                // CameraPreview(
                //                     controller!,
                //                   ),
                ),
          ),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.amber),
                  ),
                  onPressed: () async {
                    try {
                      final image = await controller!.takePicture();
                      print("if mounted");
                      if (!mounted) return;
                      print("mounted");
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPhoto(
                            image: image,
                          ),
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
