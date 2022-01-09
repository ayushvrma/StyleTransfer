import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  ShowImage({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      child: Text(message),
    )));
  }
}
