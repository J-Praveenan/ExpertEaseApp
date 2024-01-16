import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

pickVideo() async {
  final picker = ImagePicker();
  XFile? videoFile;

  try {
    videoFile = await picker.pickVideo(source: ImageSource.gallery);
    return videoFile!.path;
  } catch (e) {
    print('Error Picking Video : $e');
  }
}



pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
