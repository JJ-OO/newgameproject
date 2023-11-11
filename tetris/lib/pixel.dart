import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  final Color color;

  MyPixel({
    required this.color,
   });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: color,
        ), // Container
      ), // ClipRRect
    ); // Padding
  }
}
