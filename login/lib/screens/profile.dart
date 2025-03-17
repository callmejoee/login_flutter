import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _selectedImage;

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _selectedImage != null
              ? CircleAvatar(
                radius: 80,
                backgroundImage: FileImage(_selectedImage!),
              )
              : CircleAvatar(radius: 80, child: Icon(Icons.person, size: 80)),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _pickImageFromCamera();
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  _pickImageFromGallery();
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
            ],
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
