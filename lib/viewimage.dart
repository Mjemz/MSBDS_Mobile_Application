import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'resultspage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageDetailScreen extends StatefulWidget {

  final String imageUrl;
  const ImageDetailScreen({Key? key, required this.imageUrl}) : super(key: key);
  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}
class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late String documentId;

  @override
  void initState() {
    super.initState();
    _fetchDocumentId();
  }

  Future<void> _fetchDocumentId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user!= null) {
      setState(() {
        documentId = user.uid;
      });
    } else {
      // Handle the case where the user is not signed in
      print("No user is currently signed in.");
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://195.201.27.243/predict'));

    // This downloads the image from Firebase Storage to memory
    final response = await http.get(Uri.parse(widget.imageUrl));
    if (response.statusCode == 200) {
      Uint8List imageData = response.bodyBytes;

      //  a temporary directory
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/imagefile.jpg');
      await tempFile.writeAsBytes(imageData);

      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath('file', tempFile.path));

      var uploadResponse = await request.send();
      if (uploadResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Uploaded successfully')),
        );
        var responseData = await uploadResponse.stream.bytesToString();

        Map<String, dynamic> jsonResponse = json.decode(responseData);
        String severity= jsonResponse['severity'];

        FirebaseFirestore.instance.collection('results').add({
          'imageUrl': widget.imageUrl,
          'Severity': severity,
        });

        // Update dynamic severity field in Firestore
        await FirebaseFirestore.instance.collection('farmers').doc(documentId).update({
          'severity': severity,
        });

        print(jsonResponse);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultDisplayScreen(jsonResponse)),
        );
      } else {
        print("Failed to upload image");
      }
    } else {
      print("Failed to download image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Detail'),
      ),
      body: Center(
        child: Hero(
          tag: 'imageHero',
          child: Image.network((widget.imageUrl)), // Display the image from the URL
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => uploadImage(context),
        tooltip: 'Upload Image',
        child: const Icon(Icons.upload,color: Color(0xFF008000),),
      ),
    );
  }
}
