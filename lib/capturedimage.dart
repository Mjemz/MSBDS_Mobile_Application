import 'package:camera/camera.dart';
class CapturedImage {
  final XFile file;
  final DateTime timestamp;
  CapturedImage(this.file, this.timestamp);
}
// import 'dart:io';
// class CapturedImage {
//   final XFile file;
//   final DateTime timestamp;
//   CapturedImage(this.file, this.timestamp);
// }