import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class DisplayPhoto extends StatefulWidget {
  final XFile image;

  const DisplayPhoto({super.key, required this.image});

  @override
  State<DisplayPhoto> createState() => _DisplayPhotoState();
}

class _DisplayPhotoState extends State<DisplayPhoto> {
  String buttonText = "Save Image";
  late File imagePreview;

  _cropImage() async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: widget.image.path,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      imagePreview = File(croppedImage.path);
    }
    setState(() {});
  }

  @override
  void initState() {
    imagePreview = File(widget.image.path);
    _cropImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      //body: const Center(child: Text("image")),
      body: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          imagePreview == null
              ? Image.file(
                  File(widget.image.path),
                )
              : Image.file(
                  File(imagePreview.path),
                ),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.amber),
                  ),
                  onPressed: () {
                    if (buttonText == "Save Image") {
                      GallerySaver.saveImage(widget.image.path, albumName: "Squared").then((value) {
                        setState(() {
                          buttonText = "Image saved";
                        });
                      });
                    }
                  },
                  child: Padding(padding: const EdgeInsets.all(10.0), child: Text(buttonText)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
