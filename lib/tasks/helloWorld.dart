import 'package:flutter/material.dart';

class helloWorld extends StatefulWidget {
  const helloWorld({super.key});

  @override
  State<helloWorld> createState() => _helloWorldState();
}

class _helloWorldState extends State<helloWorld> {
  @override
  Widget build(BuildContext context) {
    return 
   Scaffold(
        body: Center(
          child: Text(
            'Hello, World!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    
    );
  }
}