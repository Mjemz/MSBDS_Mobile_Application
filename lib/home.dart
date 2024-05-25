import 'dart:io';
import 'package:cornfield/viewimage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cornfield/camerascreen.dart';
import 'package:image_picker/image_picker.dart';
import 'capturedimage.dart';
class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  List<CapturedImage> _capturedImages = [];

  @override
  void initState() {
    super.initState();
    initCamera();
  }

// Method for camera preview
  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _cameraController!.initialize();
  }

  // method for image picking in the phone gallery
  Future<void> pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile!= null) {
      // Convert XFile to File
      final File pickedImageFile = File(pickedFile.path);

      setState(() {
        // Add the picked image to the list of captured images
        _capturedImages.add(CapturedImage(pickedImageFile, DateTime.now()));
      });
    }
  }
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('MSBDS'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.upload_file), text: 'Upload Image'),
              Tab(icon: Icon(Icons.image), text: 'View Images'),
            ],
          ),
          backgroundColor:
              Colors.green, // this color sets the AppBar background color to green
        ),

        body: TabBarView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to the camera screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CameraScreen(_cameraController, onImageCaptured: (file) {
                              setState(() {
                                // Add the captured image to the list
                                _capturedImages.add(CapturedImage(file as File, DateTime.now()));
                              });
                            })
                            ),
                          );
                        },
                        child: Icon(Icons.camera, size: 100),
                      ),
                      SizedBox(
                          height:
                              8), // Add some space between the icon and the label
                      Text('Take a photo'),
                    ],
                  ),
                  SizedBox(height: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library,
                          size: 100), 
                      SizedBox(
                          height:
                              8),
                      Text('Choose from gallery'),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: _capturedImages.isEmpty
                  ? Text('No images captured yet.')
                  : ListView.builder(
                itemCount: _capturedImages.length,
                itemBuilder: (context, index) {
                  final capturedImage = _capturedImages[index];
                  return ListTile(
                    //using the hero widget to make images clickable
                    leading: Hero(
                      tag: 'imageHero$index',
                      child: Image.file(File(capturedImage.file.path)),
                    ),
                    title: Text('Captured on: ${capturedImage.timestamp}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageDetailScreen(imagePath: capturedImage.file.path),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:
              Colors.green, // Sets the color of the selected item to green
          unselectedItemColor:
              Colors.green, // Sets the color of the unselected items to green
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
