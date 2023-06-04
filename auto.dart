import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Auto extends StatefulWidget {
  const Auto({super.key});

  @override
  State<Auto> createState() => _AutoState();
}

class _AutoState extends State<Auto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Stack(
          children: [
            Positioned(left: 100,
              child: Container(decoration: const BoxDecoration(shape: BoxShape.circle),
                 
            ),),
          ]
          ),
        ),
      
    );
  }
}