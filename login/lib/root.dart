import 'package:flutter/material.dart';
import './screens/login.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // Set Login Page as the Home Page
    );
  }
}
