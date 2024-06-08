import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'resultspage.dart';
import 'package:http/http.dart' as http;

class ImageDetailScreen extends StatelessWidget {
  final String imagePath;
  const ImageDetailScreen({super.key, required this.imagePath});

  Future<void> uploadImage(BuildContext context) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://195.201.27.243/predict'));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploaded successfully')),
      );
      var responseData = await response.stream.bytesToString();
      // Assuming the server responds with JSON
      Map<String, dynamic> jsonResponse = json.decode(responseData);
      // Store the results in a way that can be accessed by the result display screen
      print(jsonResponse);
      // Navigate to the result screen after successful upload
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultDisplayScreen(jsonResponse)),
      );
    } else {
      print("Failed to upload image");
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
          child: Image.file(File(imagePath)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => uploadImage(context), // Use a lambda function to pass context
        tooltip: 'Upload Image',
        child: const Icon(Icons.upload,color: Color(0xFF008000),),
      ),
    );
  }
}
