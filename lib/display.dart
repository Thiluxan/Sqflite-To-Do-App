import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  final String title;
  final String description;
  Display({this.title, this.description});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Text(description),
      ),
    );
  }
}
