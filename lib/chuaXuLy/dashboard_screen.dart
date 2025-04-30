import 'package:flutter/material.dart';

class ProfileScreens extends StatefulWidget {
  ProfileScreens({super.key, required this.title});

  final String title;

  @override
  _ProfileScreensState createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.red,
      )
    );
  }
}
