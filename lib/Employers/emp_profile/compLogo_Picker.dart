import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompanyLogoPicker extends StatefulWidget {
  final void Function(File)
      onImageSelected; // Observer pattern: Callback function

  CompanyLogoPicker({required this.onImageSelected});

  @override
  _CompanyLogoPickerState createState() => _CompanyLogoPickerState();
}

class _CompanyLogoPickerState extends State<CompanyLogoPicker> {
  File? _image;
  final ImagePicker _picker = ImagePicker(); // Factory Method pattern

  // Strategy pattern: Two different strategies for selecting an image
  Future getImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera); // Factory Method pattern

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the state
      });
      widget
          .onImageSelected(_image!); // Observer pattern: Notifying the observer
      print(_image);
    }
  }

  Future getImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // Factory design  pattern

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the state
      });
      widget
          .onImageSelected(_image!); // Observer pattern: Notifying the observer
      print('your image path is :${_image}');
    }
  }

  _upload() async {
    Reference storage =
        FirebaseStorage.instance.ref().child("images/${_image!.path}");
    if (_image != null) storage.putFile(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Container(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text('Take a photo'),
                          onTap: () {
                            getImageFromCamera(); // Strategy pattern
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Choose from gallery'),
                          onTap: () {
                            getImageFromGallery(); // Strategy pattern
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: _image == null
                ? Icon(Icons.add_a_photo, color: Colors.grey[400])
                : Image.file(_image!, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
