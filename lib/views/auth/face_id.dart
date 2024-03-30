import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class FaceIdScreen extends StatefulWidget {
  const FaceIdScreen({super.key});

  @override
  State<FaceIdScreen> createState() => _FaceIdScreenState();
}

class _FaceIdScreenState extends State<FaceIdScreen> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    Future.delayed(Duration(seconds: 5)).then((value) {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(controller?.value.isInitialized ?? false)) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            'no camera found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
                child: AspectRatio(
              aspectRatio: controller!.value.aspectRatio,
              child: CameraPreview(controller!),
            )),
            Align(
                alignment: Alignment(0, -.45),
                child: Image.asset(
                  'assets/pics/faceMask.png',
                  color: Colors.deepPurple,
                  width: 350,
                )),
            Align(
              alignment: Alignment(0, .9),
              child: Container(
                height: 45,
                width: 175,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.deepPurple),
                child: Text('processing ...',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_circle_left,
                  color: Colors.deepPurpleAccent,
                  size: 45,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCam = cameras[1];
    controller =
        CameraController(firstCam, ResolutionPreset.max, enableAudio: false);
    await controller!.initialize();
    setState(() {});
    Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        final image = await controller!.takePicture();
        final compressedImageBytes = compressImage(image.path);
        // channel.sink.add(compressedImageBytes);
      } catch (_) {}
    });
  }

  Uint8List compressImage(String path, {int quality = 85}) {
    final image =
        img.decodeImage(Uint8List.fromList(File(path).readAsBytesSync()))!;
    final compressedImage = img.encodeJpg(image, quality: quality);
    return compressedImage;
  }
}
