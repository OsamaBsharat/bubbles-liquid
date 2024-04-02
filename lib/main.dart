import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Bubbles',
      home: BubblesScreen(),
    );
  }
}

class BubblesScreen extends StatefulWidget {
  @override
  _BubblesScreenState createState() => _BubblesScreenState();
}

class _BubblesScreenState extends State<BubblesScreen>
    with SingleTickerProviderStateMixin {
  List<Bubble> bubbles = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    createBubbles();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liquid Bubbles'),
      ),
      body: Stack(
        children: bubbles.map((bubble) {
          return Positioned(
            top: bubble.position.dy,
            left: bubble.position.dx,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    bubble.changeColor(Colors.blue);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    bubble.move(details, MediaQuery.of(context).size);
                    detectCollisions();
                  });
                },
                child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * sin(_controller.value * pi)),
                        child: Container(
                          width: bubble.size,
                          height: bubble.size,
                          decoration: BoxDecoration(
                            color: bubble.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    })),
          );
        }).toList(),
      ),
    );
  }

  void createBubbles() {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    for (int i = 0; i < 3; i++) {
      bubbles.add(Bubble(
        color: colors[Random().nextInt(colors.length)],
        size: Random().nextDouble() * 100 + 20,
        position:
            Offset(Random().nextDouble() * 300, Random().nextDouble() * 300),
      ));
    }
  }

  void detectCollisions() {
    for (int i = 0; i < bubbles.length; i++) {
      for (int j = i + 1; j < bubbles.length; j++) {
        double distance = (bubbles[i].position - bubbles[j].position).distance;
        double minDistance = (bubbles[i].size + bubbles[j].size) / 2;
        if (distance <= minDistance) {
          setState(() {
            bubbles[i].changeColor(getRandomColor());
            bubbles[j].changeColor(getRandomColor());
          });

          Offset direction = bubbles[j].position - bubbles[i].position;

          direction = direction / distance;

          bubbles[i].position -= direction * 5;
          bubbles[j].position += direction * 5;
        }
      }
    }
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}

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
