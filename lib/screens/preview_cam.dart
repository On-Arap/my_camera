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
  int cameraId = 0;
  bool isFlash = false;

  setupCameras() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(
        cameras![cameraId],
        ResolutionPreset.ultraHigh,
      );

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          controller!.setFlashMode(FlashMode.off);
          controller!.setZoomLevel(1.0);
        });
      });
    } else {
      print("NO any camera found");
    }
  }

  switchFlash() async {
    if (isFlash) {
      print(isFlash);
      controller!.setFlashMode(FlashMode.off);
    } else {
      print(isFlash);
      controller!.setFlashMode(FlashMode.torch);
    }
    setState(() {
      isFlash = !isFlash;
    });
  }

  switchCameras() async {
    cameraId = cameraId == 0 ? 1 : 0;

    if (cameras != null) {
      controller = CameraController(
        cameras![cameraId],
        ResolutionPreset.ultraHigh,
      );

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          controller!.setFlashMode(FlashMode.off);
          controller!.setZoomLevel(1.0);
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
          // const SizedBox(
          //   height: 150,
          // ),
          Expanded(
            child: Container(
                child: controller == null
                    ? const Center(child: Text("Loading Camera..."))
                    : !controller!.value.isInitialized
                        ? const Center(child: CircularProgressIndicator())
                        : Center(
                            // child: AspectRatio(
                            // aspectRatio: 1 / 1,
                            // child: ClipRect(
                            //   child: Transform.scale(
                            //     scale: controller!.value.aspectRatio / 1,
                            //     child: Center(
                            child: CameraPreview(controller!),
                            //     ),
                            //   ),
                            // ),
                            // )
                          )
                // CameraPreview(
                //                     controller!,
                //                   ),
                ),
          ),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.amber),
                  ),
                  onPressed: () async {
                    try {
                      switchCameras();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.switch_camera,
                      color: Colors.amber[800],
                      size: 20,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.amber),
                  ),
                  onPressed: () async {
                    try {
                      final image = await controller!.takePicture();
                      if (!mounted) return;

                      // final croppedImage = await ImageCropper().cropImage(
                      //   sourcePath: image.path,
                      //   maxWidth: 1080,
                      //   maxHeight: 1080,
                      // );
                      // File imagePreview = File(image.path);
                      // if (croppedImage != null) {
                      //   imagePreview = File(croppedImage.path);
                      //   setState(() {});
                      // }

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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.amber[800],
                      size: 40,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.amber),
                  ),
                  onPressed: () async {
                    try {
                      switchFlash();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      isFlash == true ? Icons.flashlight_on : Icons.flashlight_off,
                      color: Colors.amber[800],
                      size: 20,
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
