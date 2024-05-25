import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageDetailScreen extends StatelessWidget {
  final String imagePath;
  ImageDetailScreen({required this.imagePath});

  Future<void> uploadImage() async {
    var request = http.MultipartRequest('POST', Uri.parse('http:/_flask_server_address/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image uploaded successfully");
      // You can parse the response here if your server returns any data
      var responseData = await response.stream.bytesToString();
      print(responseData);
    } else {
      print("Failed to upload image");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Detail'),
      ),
      body: Center(
        child: Hero(
          tag: 'imageHero',
          child: Image.file(File(imagePath)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadImage,
        child: Icon(Icons.upload),
        tooltip: 'Upload Image',
      ),
    );
  }
}
