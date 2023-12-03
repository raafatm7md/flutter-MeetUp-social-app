import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!(controller?.value.isInitialized ?? false)){
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('no camera found', style: TextStyle(color: Colors.white),),),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(child: AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: CameraPreview(controller!),
          )),
          // Align(
          //   alignment: Alignment(0, .85),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       surfaceTintColor: Colors.red,
          //     ),
          //     child: Text,
          //   ),
          // )
        ],
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
      try{
        final image = await controller!.takePicture();
        final compressedImageBytes = compressImage(image.path);
        // channel.sink.add(compressedImageBytes);
      } catch (_){}
    });
  }

  Uint8List compressImage(String path, {int quality = 85})
  {
    final image = img.decodeImage(Uint8List.fromList(File(path).readAsBytesSync()))!;
    final compressedImage = img.encodeJpg(image, quality: quality);
    return compressedImage;
  }
}
