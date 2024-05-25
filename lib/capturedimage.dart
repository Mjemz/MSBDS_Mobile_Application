import 'dart:io';
class CapturedImage {
  final File file; // Assuming File is imported from 'dart:io'
  final DateTime timestamp;

  CapturedImage(this.file, this.timestamp);
}