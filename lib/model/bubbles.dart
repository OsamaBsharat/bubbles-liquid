
import 'package:flutter/material.dart';


class Bubble {
  Offset position;
  double size;
  Color color;

  Bubble({required this.position, required this.size, required this.color});

  void move(DragUpdateDetails dragDetails, Size screenSize) {
    position = Offset(
      (position.dx + dragDetails.delta.dx).clamp(0.0, screenSize.width - size),
      (position.dy + dragDetails.delta.dy).clamp(0.0, screenSize.height - size),
    );
  }

  void changeColor(Color newColor) {
    color = newColor;
  }
}
