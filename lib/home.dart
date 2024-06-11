import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cornfield/viewimage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cornfield/camerascreen.dart';
import 'package:image_picker/image_picker.dart';
import 'capturedimage.dart';
import 'notifications_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

//import 'package:marquee/marquee.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});
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
    await _initializeControllerFuture;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // Method for image picking in the phone gallery
  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      //final XFile pickedImageFile = XFile(pickedFile.path);
      if (pickedFile != null) {
        final File pickedImageFile = File(pickedFile.path);
        try {
          // Generate a unique name for the image file
          String fileName = '${DateTime
              .now()
              .millisecondsSinceEpoch}.jpg'; // Assuming JPEG format

          // Create a reference to the file you want to upload
          firebase_storage.Reference ref = firebase_storage.FirebaseStorage
              .instance.ref('images/$fileName');

          // Upload the file to the path
          firebase_storage.UploadTask uploadTask = ref.putFile(pickedImageFile);

          // Wait until the upload is complete
          await uploadTask.whenComplete(() async {
            // Once the upload is complete, get the download URL
            String downloadUrl = await ref.getDownloadURL();

            // Save the download URL to Firestore
            FirebaseFirestore.instance.collection('capturedImages').doc(
                fileName).set({
              'url': downloadUrl,
              'timestamp': DateTime.now(),
            });

            // Update the state to add the picked image to the list of captured images
            setState(() {
              _capturedImages.add(
                  CapturedImage(XFile(downloadUrl), DateTime.now()));
            });
          });
        } catch (e) {
          print(e);
        }
      } // Updates the state to add the picked image to the list of captured images
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: Stack(
          children: [
            // TabBarView goes here
            Expanded(
            child: TabBarView(
              children: [
                Center(
                  child: Column(
                    children: [
                      //outer container
                      Container(
                        padding:EdgeInsets.only(top:  100),
                        color: Colors.green[300],
                        width: 500,
                        height: MediaQuery.of(context).size.height * 0.87, // 45% of screen height
                        child: Column(
                          children: [
                            //inner container first
                            Container(
                              padding:EdgeInsets.only(top:  100),
                              width: 500,
                              height: 300,
                              color:  Color(0xFFFFFFFF),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the camera screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CameraScreen(_cameraController, onImageCaptured: (file) async {
                                          try {
                                            // Generate a unique name for the image file
                                            String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg'; // Assuming JPEG format

                                            // Create a reference to the file you want to upload
                                            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('images/$fileName');

                                            // Upload the file to the path
                                            firebase_storage.UploadTask uploadTask = ref.putFile(File(file.path));

                                            // Wait until the upload is complete
                                            await uploadTask.whenComplete(() async {
                                              // Once the upload is complete, get the download URL
                                              String downloadUrl = await ref.getDownloadURL();

                                              // Save the download URL to Firestore
                                              FirebaseFirestore.instance.collection('capturedImages').doc(fileName).set({
                                                'url': downloadUrl,
                                                'timestamp': DateTime.now(),
                                              });

                                              // Update the state to add the captured image to the list of captured images
                                              setState(() {
                                                _capturedImages.add(CapturedImage(XFile(downloadUrl), DateTime.now()));
                                              });
                                            });
                                          } catch (e) {
                                             print(e);
                                          }
                                        })),
                                      );
                                    },
                                    child: const Icon(Icons.camera_alt, size: 100, color: Color(0xFF008000)),
                                ),
                                  const SizedBox(height: 8),
                                  const Text('Take a photo'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // I call pickImageFromGallery method
                                    pickImageFromGallery().then((_) {
                                     // no need for action because i used the set state
                                    });
                                  },
                                  child:  Icon(Icons.photo_library, size: 80, color: Color(0xFF008000),),
                                ),
                                SizedBox(height: 8),
                                const Text('Choose from gallery'),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Center(
                  child:
                  // _capturedImages.isEmpty
                  //     ? const Text('No images captured yet.')
                  //     :
                  StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('capturedImages').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('yyyy-MM-dd\nHH:mm:ss.SSS').format(now);
            return ListTile(
              leading: Image.network(data['url']),
              title: Text('Captured on: $formattedDate'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageDetailScreen(imageUrl: data['url']),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
            ),
          ),
        ],
      ),
     ),
            SafeArea(
              top: false, // Prevents the safe area from applying to the custom header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar-like structure
                  Container(
                    width: MediaQuery.of(context).size.width * 1.0, // 50% of screen width
                    height: MediaQuery.of(context).size.height * 0.25, // 25% of screen height
                    padding:  EdgeInsets.all(16), // Padding inside the outer container
                    decoration: const BoxDecoration(
                      color: Color(0xFF008000), // Background color of the AppBar-like structure
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0), // Rounded corners
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/images/MSBDSLogo.png', width: 70, height: 70),
                              Text('MBSDS', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20),),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the camera screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotificationsPage(),
                                  ),
                                );
                              },
                              child: const Icon(Icons.notifications, size: 70, color: Color(0xFFFFFFFF)),
                            ),
                          ],
                        ),
                        const Spacer(), // This pushes the inner container to the bottom
                        Container(
                          width: 300,
                          height: 50,
                          padding:  EdgeInsets.all(16), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Colors.green[200], // Background color of the rectangle for tabs
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30), // Rounded corners
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: const TabBar(
                            tabs: [
                              Tab(
                                child: Row(
                                  children:[
                                    Text('Upload Image',style: TextStyle(fontSize: 10),),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                    children:[
                                      Text('View Images',style: TextStyle(fontSize: 10) ),
                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color(0xFF008000),
          unselectedItemColor: Colors.green[100],
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}









