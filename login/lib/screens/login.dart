import 'package:flutter/material.dart';
import '../db/db.dart';
import './profile.dart';
import './signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPass = TextEditingController();

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      final user = await DatabaseHelper.instance.getUser(
        txtEmail.text,
        txtPass.text,
      );

      if (user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login Successful!")));

        // Navigate to Profile Page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Email or Password")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
              ),
              const SizedBox(height: 20),

              // Email Input
              TextFormField(
                controller: txtEmail,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Email is required";
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Password Input
              TextFormField(
                controller: txtPass,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 8)
                    return "Password must be at least 8 characters";
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  minimumSize: const Size(300, 60),
                ),
                child: const Text("Login", style: TextStyle(fontSize: 25)),
              ),
              const SizedBox(height: 20),

              // Signup Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
