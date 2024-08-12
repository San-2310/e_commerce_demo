import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabylonJSViewer(
        src: 'https://models.babylonjs.com/boombox.glb',
      ),
    );
  }
}
