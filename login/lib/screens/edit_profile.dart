import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/db.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController studentIdController;
  late TextEditingController genderController;
  late TextEditingController levelController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['name']);
    emailController = TextEditingController(text: widget.user['email']);
    studentIdController = TextEditingController(text: widget.user['studentID']);
    genderController = TextEditingController(text: widget.user['gender']);
    levelController = TextEditingController(text: widget.user['level']);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = {
        'name': nameController.text,
        'email': emailController.text,
        'studentID': studentIdController.text,
        'gender': genderController.text,
        'level': levelController.text,
        'imagePath': _imageFile?.path ?? widget.user['imagePath'],
      };

      await DatabaseHelper.instance.updateUser(widget.user['id'], updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = _imageFile?.path ?? widget.user['imagePath'];

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      currentImage != null && currentImage.isNotEmpty
                          ? FileImage(File(currentImage))
                          : const AssetImage('assets/placeholder.png')
                              as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter a name" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: studentIdController,
                decoration: const InputDecoration(labelText: "Student ID"),
                validator:
                    (value) => value!.isEmpty ? "Enter student ID" : null,
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value:
                    (genderController.text == "Male" ||
                            genderController.text == "Female")
                        ? genderController.text
                        : null,
                decoration: const InputDecoration(labelText: "Gender"),
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                ],
                onChanged: (value) {
                  setState(() {
                    genderController.text = value!;
                  });
                },
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Select gender" : null,
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value:
                    ["1", "2", "3", "4"].contains(levelController.text)
                        ? levelController.text
                        : null,
                decoration: const InputDecoration(labelText: "Level"),
                items:
                    ["1", "2", "3", "4"]
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text("Level $level"),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    levelController.text = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
