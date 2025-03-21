import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/db.dart';
import './edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await DatabaseHelper.instance.getUserById(widget.userId);
    setState(() {
      user = data;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && user != null) {
      final updatedUser = Map<String, dynamic>.from(user!);
      updatedUser['imagePath'] = pickedFile.path;

      await DatabaseHelper.instance.updateUser(user!['id'], updatedUser);

      setState(() {
        user = updatedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    user!['imagePath'] != null && user!['imagePath'].isNotEmpty
                        ? FileImage(File(user!['imagePath']))
                        : const AssetImage('assets/placeholder.png')
                            as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow("Name", user!['name']),
            _buildInfoRow("Email", user!['email']),
            _buildInfoRow("Student ID", user!['studentID']),
            _buildInfoRow("Gender", user!['gender']),
            _buildInfoRow("Level", user!['level']),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user!),
                  ),
                ).then((_) {
                  _loadUser(); // Reload user info after editing
                });
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value ?? '-'),
      ],
    );
  }
}
