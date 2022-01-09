import 'dart:typed_data';

import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  ShowImage({required this.img});
  final Image img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      child: img,
    )));
  }
}
