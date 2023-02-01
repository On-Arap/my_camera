import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class DisplayPhoto extends StatefulWidget {
  final XFile image;

  const DisplayPhoto({super.key, required this.image});

  @override
  State<DisplayPhoto> createState() => _DisplayPhotoState();
}

class _DisplayPhotoState extends State<DisplayPhoto> {
  String buttonText = "Save Image";

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
          Image.file(
            File(widget.image.path),
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
          ),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
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
