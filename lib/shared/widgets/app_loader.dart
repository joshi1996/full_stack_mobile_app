import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({this.size = 32, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(),
    );
  }
}
