import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
class CameraScreen extends StatefulWidget {
  final CameraController? cameraController;
  final Function(XFile) onImageCaptured; // Callback to handle the captured image
  CameraScreen(this.cameraController, {required this.onImageCaptured});
  @override
  _CameraScreenState createState() => _CameraScreenState();
}
class _CameraScreenState extends State<CameraScreen> {
  XFile? _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          CameraPreview(widget.cameraController!),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // Capture the image
                    final XFile? file = await widget.cameraController!.takePicture();
                    if (file != null) {
                      // Call the callback with the captured image
                      widget.onImageCaptured(file);
                      // Pop the CameraScreen to return to the HomeScreen
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
